function main()
    lines = readlines("input.txt")
    DIRS = Dict(
        'U' => ( 0, 1),
        'R' => ( 1, 0),
        'D' => ( 0,-1),
        'L' => (-1, 0),
    )
    paths = map(x -> split(x, ","), lines)
    nearest = Inf
    fewest = Inf
    points = Dict()

    # First wire
    loc = (0, 0)
    walked = 0
    for p in paths[1]
        direction = DIRS[p[1]]
        steps = parse(Int, p[2:end])
        for _ in 1:steps
            loc = loc .+ direction
            walked += 1

            # Keep the shorter walked distance
            # if the wire intersects itself
            if !haskey(points, loc)
                points[loc] = walked
            end
        end
    end

    # Second wire
    loc = (0, 0)
    walked = 0
    for p in paths[2]
        direction = DIRS[p[1]]
        steps = parse(Int, p[2:end])
        for _ in 1:steps
            loc = loc .+ direction
            walked += 1

            if haskey(points, loc)
                # Part 1
                manhattan_distance = sum(map(abs, loc))
                if manhattan_distance < nearest
                    nearest = manhattan_distance
                end
                # Part 2
                total_steps = walked + points[loc]
                if total_steps < fewest
                    fewest = total_steps
                end
            end
        end
    end

    println("(Part 1) Manhattan distance of the closest intersection is $nearest")
    println("(Part 2) Fewest combined steps the wires must take is $fewest")
end

@time main()
