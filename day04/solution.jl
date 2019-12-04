function digitcounts(n)
    z = zeros(Int, 10)
    for c in digits(n)
        z[c+1] += 1
    end
    return z
end

function main()
    if length(ARGS) < 2
        INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
        INPUT = read(INPUTFILE, String)
        (lower, upper) = split(INPUT, "-")
    else
        lower = ARGS[1]
        upper = ARGS[2]
    end
    lower = parse(Int, lower)
    upper = parse(Int, upper)

    numbers = lower:upper

    not_decreasing = filter(x -> issorted(digits(x), rev=true), numbers)

    # Because the digits are sorted digit count > 1 implies they must
    # be consecutive, so we can just count the digits:
    counts = map(x -> digitcounts(x), not_decreasing)

    part1 = length(filter(x -> max(x...) > 1, counts))
    println("(Part1) $part1 different passwords")
    
    part2 = length(filter(x -> in(2, x), counts))
    println("(Part2) $part2 different passwords")
end

@time main()
