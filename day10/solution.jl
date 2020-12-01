using LinearAlgebra

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    lines = readlines(INPUTFILE)

    asteroids = []
    for (y, line) in enumerate(lines)
        for (x, ch) in enumerate(line)
            if ch == '#'
                push!(asteroids, x + y*im - 1 - 1im)
            end
        end
    end
    @show length(asteroids)

    # Part 1
    angles = map(x -> [angle(x-other) for other in asteroids if other != x], asteroids)
    max_seen, index = findmax(angles .|> unique .|> length)
    best = asteroids[index]
    x, y = real(best), imag(best)
    println("(Part 1) Best place for the station is the asteroid at ($x, $y), " *
            "from which you can see $max_seen asteroids.")
end

@time main()