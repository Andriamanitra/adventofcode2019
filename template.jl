function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    result = 0
    #lines = readlines(INPUTFILE)
    #numbers = map(x -> parse(Int, x), readlines(INPUTFILE))
    #chars = read(INPUTFILE, String)
    #word_lists = map(x -> split(x, " "), readlines(INPUTFILE))
    #dict = Dict(tuple(map(x -> split(x, ": "), readlines(INPUTFILE))))
    #for line in eachline(INPUTFILE)

    println("Result is $result")
end

@time main()
