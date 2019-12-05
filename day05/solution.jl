using Printf


function compute(numbers, input=missing)
    i = 1
    while true
        opcode = numbers[i] % 100
        if opcode == 99 # End program
            println()
            return numbers[1]
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
            if ismissing(input)
                print("input: ")
                input = parse(Int, readline())
            end
            numbers[out] = input
            i += 2
        elseif opcode == 4
            # Output
            output = mode[1] == 1 ? numbers[i+1] : numbers[numbers[i+1]+1]
            println(output)
            i += 2
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
            throw(ErrorException("Invalid opcode "*string(opcode)))
        end
    end
end

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    chars = read(INPUTFILE, String)
    numbers = map(x -> parse(Int, x), split(chars, ","))
    println("(Part 1) output:")
    compute(copy(numbers), 1)
    print("(Part 2) Diagnostic code is ")
    compute(copy(numbers), 5)
end

@time main()
