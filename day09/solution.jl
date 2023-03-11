Nums = Vector{Int64}

mutable struct IntCode
    ip::Int64
    relative_base::Int64
    inputs::Nums
    outputs::Nums
    code::Nums
    tape::Dict{Int64, Int64}
    function IntCode(code)
        tape = Dict(zip(Iterators.countfrom(0), code))
        new(0, 0, Nums(), Nums(), code, tape)
    end
end

@enum OpCode begin
    add = 1
    mul = 2
    input = 3
    output = 4
    jump_if_true = 5
    jump_if_false = 6
    lt = 7
    eq = 8
    adjust_relative_base = 9
    halt = 99
end

@enum ParamMode begin
    position = 0
    immediate = 1
    relative = 2
end

num_params = Base.ImmutableDict(
    add => 3,
    mul => 3,
    input => 1,
    output => 1,
    jump_if_true => 2,
    jump_if_false => 2,
    lt => 3,
    eq => 3,
    adjust_relative_base => 1,
    halt => 0,
)

struct Instruction
    opcode::OpCode
    param_modes::Tuple{Vararg{ParamMode}}
    function Instruction(num)
        opcode = OpCode(num % 100)
        param_modes = get_param_modes(num, num_params[opcode])
        new(opcode, param_modes)
    end
end

function get_param_modes(num, num_params)
    param_modes = Vector{ParamMode}(undef, num_params)
    num ÷= 100
    for i = 1:num_params
        param_modes[i] = ParamMode(num % 10)
        num ÷= 10
    end
    tuple(param_modes...)
end

function get_tape(program::IntCode)::Nums
    len = maximum(program.tape).first + 1
    tape = zeros(Int64, len)
    for (k, v) in program.tape
        tape[k + 1] = v
    end
    tape
end

function read_instruction(program::IntCode)::Instruction
    instruction = Instruction(get_at_ip(program))
end

function get_at_ip(program::IntCode)
    program.tape[program.ip]
end

function get_at(program::IntCode, idx)
    if idx < 0
        error("Can't access tape at negative index ($idx)")
    end
    get(program.tape, idx, 0)
end

function read_param!(program::IntCode, mode::ParamMode)
    if mode == position
        pos = get_at_ip(program)
        param = get_at(program, pos)
    elseif mode == immediate
        param = get_at_ip(program)
    elseif mode == relative
        pos = get_at_ip(program)
        param = get_at(program, program.relative_base + pos)
    else
        error("Unsupported mode for read_param!: $mode")
    end
    program.ip += 1
    param
end

function write!(program::IntCode, value::Int64, mode::ParamMode)
    if mode == position
        idx = read_param!(program, immediate)
    elseif mode == relative
        idx = program.relative_base + read_param!(program, immediate)
    else
        error("Unsupported mode for write!: $mode")
    end
    if idx < 0
        error("Can't write at negative index ($idx)")
    end
    program.tape[idx] = value
end

function add!(program::IntCode, in1::ParamMode, in2::ParamMode, out::ParamMode)
    a = read_param!(program, in1)
    b = read_param!(program, in2)
    write!(program, a + b, out)
end

function mul!(program::IntCode, in1::ParamMode, in2::ParamMode, out::ParamMode)
    a = read_param!(program, in1)
    b = read_param!(program, in2)
    write!(program, a * b, out)
end

function input!(program::IntCode, out::ParamMode)
    value = popfirst!(program.inputs)
    write!(program, value, out)
end

function output!(program::IntCode, mode::ParamMode)
    val = read_param!(program, mode)
    push!(program.outputs, val)
end

function jump_if!(program::IntCode, cond, in1::ParamMode, out::ParamMode)
    param1 = read_param!(program, in1)
    param2 = read_param!(program, out)
    if cond(param1)
        program.ip = param2
    end
end

function cmp_with!(program::IntCode, cmp_fn, in1::ParamMode, in2::ParamMode, out::ParamMode)
    a = read_param!(program, in1)
    b = read_param!(program, in2)
    result = cmp_fn(a, b)
    write!(program, Int(result), out)
end

function adjust_relative_base!(program::IntCode, mode::ParamMode)
    adjustment = read_param!(program, mode)
    program.relative_base += adjustment
end

function execute!(program::IntCode)
    while true
        instruction = read_instruction(program)
        program.ip += 1
        if instruction.opcode == halt
            return
        elseif instruction.opcode == add
            add!(program, instruction.param_modes...)
        elseif instruction.opcode == mul
            mul!(program, instruction.param_modes...)
        elseif instruction.opcode == input
            input!(program, instruction.param_modes...)
        elseif instruction.opcode == output
            output!(program, instruction.param_modes...)
        elseif instruction.opcode == jump_if_true
            jump_if!(program, !=(0), instruction.param_modes...)
        elseif instruction.opcode == jump_if_false
            jump_if!(program, ==(0), instruction.param_modes...)
        elseif instruction.opcode == lt
            cmp_with!(program, <, instruction.param_modes...)
        elseif instruction.opcode == eq
            cmp_with!(program, ==, instruction.param_modes...)
        elseif instruction.opcode == adjust_relative_base
            adjust_relative_base!(program, instruction.param_modes...)
        else
            error("Not implemented: $instruction")
        end
    end
end

function compute(nums, nums_in=[])
    program = IntCode(nums)
    append!(program.inputs, nums_in)
    execute!(program)
    program
end

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    chars = read(INPUTFILE, String)
    numbers = map(x -> parse(Int, x), split(chars, ","))
    part1 = compute(numbers, 1)
    println("(Part 1) output:")
    println(part1.outputs)
    part2 = compute(numbers, 2)
    println("(Part 2) output:")
    println(part2.outputs)
end


using Test: @test
# Day 2 examples
@test get_tape(compute([1,0,0,0,99])) == [2,0,0,0,99]
@test get_tape(compute([2,3,0,3,99])) == [2,3,0,6,99]
@test get_tape(compute([2,4,4,5,99,0])) == [2,4,4,5,99,9801]
@test get_tape(compute([1,1,1,4,99,5,6,0,99])) == [30,1,1,4,2,5,6,0,99]
@test get_tape(compute([1,9,10,3,2,3,11,0,99,30,40,50])) == [3500,9,10,70,2,3,11,0,99,30,40,50]

# Day 5 examples
@test compute(
    [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
    [7]).outputs == [999]
@test compute(
    [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
    [8]).outputs == [1000]
@test compute(
    [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99],
    [9]).outputs == [1001]
@test compute([3,9,8,9,10,9,4,9,99,-1,8], [7]).outputs == [0]
@test compute([3,9,8,9,10,9,4,9,99,-1,8], [8]).outputs == [1]
@test compute([3,3,1108,-1,8,3,4,3,99], [7]).outputs == [0]
@test compute([3,3,1108,-1,8,3,4,3,99], [8]).outputs == [1]
@test compute([3,9,7,9,10,9,4,9,99,-1,8], [7]).outputs == [1]
@test compute([3,9,7,9,10,9,4,9,99,-1,8], [8]).outputs == [0]
@test compute([3,3,1107,-1,8,3,4,3,99], [7]).outputs == [1]
@test compute([3,3,1107,-1,8,3,4,3,99], [8]).outputs == [0]

# Day 9 examples
@test compute([104,123,99]).outputs == [123]
@test compute([1102,34915192,34915192,7,4,7,99,0]).outputs == [1219070632396864]
@test compute([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]).outputs == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

# test relative base
@test compute([109,-1,99]).relative_base == -1
@test compute([109,69,204,-69,99]).outputs == [109]

@time main()
