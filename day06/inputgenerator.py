from random import randint

def generate_counter():
    i = 0
    while True:
        i += 1
        yield "P"+str(i)

def generate_tree(root, depth):
    new_node = next(counter)
    print(f"{root}){new_node}")
    if depth == 0:
        return
    else:
        rand = randint(0, 10)
        if rand == 0 or depth==MAXDEPTH:
            n = 3
        elif rand == 1:
            n = 2
        elif rand < 9:
            n = 1
        else:
            n = 0
        for _ in range(n):
            generate_tree(new_node, depth-1)

counter = generate_counter()
MAXDEPTH = 500
generate_tree("COM", MAXDEPTH)
