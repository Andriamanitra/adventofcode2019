tree = Dict()

mutable struct TreeNode
    id::String
    parent::Union{String, Missing}
    children::Vector{String}
end

function count_orbits(node, depth=0)
    orbits = depth
    if tree[node].children == []
        return orbits
    else
        for child in tree[node].children
            orbits += count_orbits(child, depth+1)
        end
    end
    return orbits
end

function parents(x::String)
    p = []
    while !ismissing(tree[x].parent)
        x = tree[x].parent
        push!(p, x)
    end
    return p
end

function distance(a::String, b::String)
    for (i, p1) in enumerate(parents(a))
        for (j, p2) in enumerate(parents(b))
            if tree[p1].id == tree[p2].id
                return i+j-2
            end
        end
    end
end

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    lines = readlines(INPUTFILE)
    orbits = map(x -> split(x, ")"), lines)

    # Build a tree
    for (parent, child) in orbits
        if haskey(tree, parent)
            push!(tree[parent].children, child)
        else
            tree[parent] = TreeNode(parent, missing, [child])
        end
        if haskey(tree, child)
            tree[child].parent = parent
        else
            tree[child] = TreeNode(child, parent, [])
        end
    end

    # Part 1
    result = count_orbits("COM")
    println("(Part 1) Total number of orbits is $result")

    # Part 2
    result = distance("YOU", "SAN")
    println("(Part 2) Minimum number of orbital transfers is $result")

end

@time main()
