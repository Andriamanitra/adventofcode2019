using Printf

function main()
    result = 0
    #lines = readlines("input.txt")
    #numbers = map(x -> parse(Int, x), readlines("input.txt"))
    #chars = read("input.txt", Str)
    #word_lists = map(x -> split(x, " "), readlines("input.txt"))
    #dict = Dict(tuple(map(x -> split(x, ": "), readlines("input.txt"))))
    #for line in eachline("input.txt")

    @printf "Result is %d\n" result
end

@time main()
