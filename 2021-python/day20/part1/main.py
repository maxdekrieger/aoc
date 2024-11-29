from __future__ import annotations

input = '../data/input.txt'

def main():
    with open(input, 'r') as file:
        lines = file.readlines()
        algorithm = list(map(lambda c : c == '#', list(lines[0].strip())))
        image: list[list[bool]] = [list(map(lambda c : c == '#', list(line.strip()))) for line in lines[2:]]

        printimage('Step 0:', image)
        for step in range(2):
            increasecanvas(image, step + 1)
            printimage(f'{step + 1} (pre-process):', image)
            image = enhance(image, algorithm)
            printimage(f'{step + 1}:', image)

        print(sum([sum([1 if b else 0 for b in row]) for row in image]))

def enhance(image: list[list[bool]], algorithm: list[bool]) -> list[list[bool]]:
    new_image = []
    maxheight = len(image) - 1
    maxwidth = len(image[0]) - 1
    for y, row in enumerate(image):
        new_row = []
        for x, b in enumerate(row):
            northwest = b if (y == 0 or x == 0) else image[y-1][x-1]
            north = b if (y == 0) else image[y-1][x]
            northeast = b if (y == 0 or x == maxwidth) else image[y-1][x+1]

            west = b if (x == 0) else image[y][x-1]
            center = image[y][x]
            east = b if (x == maxwidth) else image[y][x+1]

            southwest = b if (y == maxheight or x == 0) else image[y+1][x-1]
            south = b if (y == maxheight) else image[y+1][x]
            southeast = b if (y == maxheight or x == maxwidth) else image[y+1][x+1]

            boolean_list = [
                northwest, north, northeast,
                west, center, east,
                southwest, south, southeast
            ]
            binary_str = ''.join(['1' if b else '0' for b in boolean_list])
            index = int(binary_str, 2)
            new_row.append(algorithm[index])
        new_image.append(new_row)
    return new_image

def increasecanvas(image: list[list[bool]], step):
    b = (step % 2 == 0) if input.endswith('input.txt') else False
    if len(image) >= 3:
        if True in image[0] or True in image[1] or True in image[2]:
            image.insert(0, [b for x in range(len(image[0]))])
            image.insert(0, [b for x in range(len(image[0]))])
            image.insert(0, [b for x in range(len(image[0]))])

        if True in image[len(image) - 1] or True in image[len(image) - 2] or True in image[len(image) - 3]:
            image.append([b for x in range(len(image[0]))])
            image.append([b for x in range(len(image[0]))])
            image.append([b for x in range(len(image[0]))])

    if len(image) > 0 and len(image[0]) >= 3:
        width = len(image[0])
        prepend = False
        append = False
        for row in image:
            if row[0] or row[1] or row[3]: prepend = True
            if row[width - 1] or row[width - 2] or row[width - 3]: append = True

        if prepend:
            for row in image:
                row.insert(0, b)
                row.insert(0, b)
                row.insert(0, b)

        if append:
            for row in image:
                row.append(b)
                row.append(b)
                row.append(b)

def printimage(title: str, image: list[list[bool]]):
    print(f'\n{title}')
    for row in image:
        print("".join(list(map(lambda b: '#' if b else '.', row))))

if __name__ == '__main__':
    main()
