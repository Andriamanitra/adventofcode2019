using Printf

function main()
    #lines = readlines("input.txt") 
    #chars = read("input.txt", Str)
    #word_lists = map(x -> split(x, " "), readlines("input.txt"))
    #dict = Dict(tuple(map(x -> split(x, ": "), readlines("input.txt"))))
    for line in lines
        println(line)
    end
end

main()
