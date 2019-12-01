using Printf

function fuel(n::Int)
    if n <= 8
        return 0
    else
        remaining = div(n, 3) - 2
        return remaining + fuel(remaining)
    end
end

function main()
    result = 0
    for line in eachline("input.txt")
        mass = parse(Int, line)
        result += fuel(mass)
    end
    @printf "Result is %d\n" result
end

@time main()
