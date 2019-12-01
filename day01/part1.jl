using Printf

fuel(n::Int) = div(n, 3) - 2

function main()
    result = 0
    for line in eachline("input.txt")
        mass = parse(Int, line)
        result += fuel(mass)
    end
    @printf "Result is %d\n" result
end

@time main()
