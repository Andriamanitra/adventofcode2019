using Printf


function compute(numbers, noun, verb)
    i = 1
    numbers[2] = noun
    numbers[3] = verb
    while true
        opcode = numbers[i]
        if opcode == 99
            return numbers[1]
        end
        left   = numbers[i+1] +1 # STUPID ZERO-BASED
        right  = numbers[i+2] +1 # INDEXING IS USED
        out    = numbers[i+3] +1 # IN THIS STUPID PROBLEM
        if opcode == 1
            numbers[out] = numbers[left] + numbers[right]
        elseif opcode == 2
            numbers[out] = numbers[left] * numbers[right]
        else
            throw(ErrorException("Invalid opcode"))
        end
        i += 4
    end
end

function main()
    chars = read("input.txt", String)
    numbers = map(x -> parse(Int, x), split(chars, ","))

    # Part 1
    @printf "Part1 result is %d\n" compute(copy(numbers), 12, 2)

    # Part 2
    answer = 19690720
    possible_answer = 0
    for noun = 0:99
        for verb = 0:99
            try
                possible_answer = compute(copy(numbers), noun, verb)
            catch err
                println(err)
                continue
            end
            if possible_answer == answer
                @printf "Part2 result is %d\n" (100 * noun + verb)
                return
            end
        end
    end 
end

@time main()
