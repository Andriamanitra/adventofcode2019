# Instead of own permutations() function you could
# use a better one from Combinatorics package
function permutations(it)
    if length(it) < 2
        return it
    else
        perms = []
        for i = 1:length(it)
            others = copy(it)
            first_el = splice!(others, i)
            for rest in permutations(others)
                push!(perms, vcat(first_el, rest))
            end
        end
        return perms
    end
end

struct HaltException <: Exception
end

function compute(numbers, inputs, i=1)
    i_ = 1
    while true
        opcode = numbers[i] % 100
        if opcode == 99 # End program
            #println("HALTED")
            throw(ErrorException("Halted"))
        end

        # 1 == immediate mode, 0 == position mode
        mode = digits(round(Int, numbers[i]/100))
        # leading zeros are omitted so pad the array with zeros
        append!(mode, [0, 0, 0])

        if opcode in Set([1, 2, 7, 8])
            left = numbers[i+1]
            left = mode[1] == 1 ? left : numbers[left+1]
            right = numbers[i+2]
            right = mode[2] == 1 ? right : numbers[right+1]
            out = numbers[i+3] + 1

            if opcode == 1
                # Sum
                numbers[out] = left + right
            elseif opcode == 2
                # Multiplication
                numbers[out] = left * right
            elseif opcode == 7
                # Less than
                numbers[out] = Int(left < right)
            elseif opcode == 8
                # Equals
                numbers[out] = Int(left == right)
            end
            i += 4
        elseif opcode == 3
            # Input
            out = numbers[i+1] + 1
            input = inputs[i_]
            i_ += 1
            numbers[out] = input
            input = missing
            i += 2
        elseif opcode == 4
            # Output
            output = mode[1] == 1 ? numbers[i+1] : numbers[numbers[i+1]+1]
            #println(output)
            i += 2
            return (i, output)
        elseif opcode == 5 || opcode == 6
            cond = mode[1] == 1 ? numbers[i+1] : numbers[numbers[i+1]+1]
            jumpto = mode[2] == 1 ? numbers[i+2]+1 : numbers[numbers[i+2]+1]+1
            if opcode == 5 && cond != 0
                # jump-if-true
                i = jumpto
            elseif opcode == 6 && cond == 0
                # jump-if-false
                i = jumpto
            else
                i += 3
            end
        else
            println("Ran into invalid opcode $opcode at index $i")
            exit(-1)
        end
    end
end

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    chars = read(INPUTFILE, String)
    numbers = map(x -> parse(Int, x), split(chars, ","))

    max_val = -Inf
    for perm in permutations(collect(0:4))
        res = 0
        for phase in perm
            (_, res) = compute(copy(numbers), (phase, res))
        end
        max_val = Int(max(max_val, res))
    end
    println("(Part 1) Highest signal is $max_val")

    AMP_COUNT = 5
    max_val = -Inf
    for perm in permutations(collect(5:9))
        res = 0
        last = 0
        
        # Instruction pointers
        ips = [1 for _ = 1:AMP_COUNT]
        
        # States of each amplifier
        abcde = [copy(numbers) for _ = 1:AMP_COUNT]

        # Set initial phases
        for i in 1:AMP_COUNT
            (ips[i], res) = (ips[i], res) = compute(abcde[i], (perm[i], res), ips[i])
        end
        
        # Enter feedback loop, halt throws an exception which is
        # caught (I don't like this solution but it works)
        try
            while true
                for i in 1:AMP_COUNT
                    (ips[i], res) = compute(abcde[i], (res), ips[i])
                end
                last = res
            end
        catch
            max_val = Int(max(max_val, last))
        end
    end
    println("(Part 2) Highest signal is $max_val")
end

@time main()
