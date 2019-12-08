WIDTH = 25
HEIGHT = 6

function printImage(img)
    printable = map(x -> x == 0 ? ' ' : '█', img)
    for i in 1:HEIGHT
        println(join(printable[:, i], ""))
    end    
end

function main()
    INPUTFILE = length(ARGS) == 1 ? ARGS[1] : "input.txt"
    chars = strip(read(INPUTFILE, String))
    numbers = map(x -> parse(Int, x), split(chars, ""))
    
    pic_count = div(length(numbers), WIDTH*HEIGHT)
    pics = reshape(numbers, (WIDTH, HEIGHT, pic_count))
    
    # Part 1
    counts = mapslices(p -> count(==(0), p), pics, dims=(1,2))[1,1,:]
    (_, pic_index) = findmin(counts)
    pic = view(pics, :, :, pic_index)
    result = count(==(1), pic) * count(==(2), pic)
    println("(Part 1) $result")

    # Part 2
    pic2 = mapslices(p -> first(filter(<(2), p)), pics, dims=3)[:,:,1]
    println("(Part 2) Picture:")
    printImage(pic2)
end

@time main()
