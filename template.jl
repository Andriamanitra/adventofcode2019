using Printf

function main()
    lines = readlines("input.txt")
    #numbers = map(x -> parse(Int, x), readlines("input.txt"))
    #chars = read("input.txt", Str)
    #word_lists = map(x -> split(x, " "), readlines("input.txt"))
    #dict = Dict(tuple(map(x -> split(x, ": "), readlines("input.txt"))))
    result = 0
    for line in lines
        println(line)
    end
    @printf "Result is %d\n" result
end

@time main()
