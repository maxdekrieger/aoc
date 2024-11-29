def main():
    with open('../data/input.txt', 'r') as file:
        max_x = 0
        max_y = 0
        for line in file:
            split = line.strip().split(',')
            if len(split) == 2:
                x = int(split[0])
                y = int(split[1])
                if x > max_x: max_x = x
                if y > max_y: max_y = y

        file.seek(0)
        dots: list[list[bool]] = [[False for x in range(max_x + 1)] for y in range(max_y + 1)]
        folds: list[tuple[str, int]] = []

        print('dots rows: ' + str(len(dots)))
        print('dots columns: ' + str(len(dots[0])))

        for line in file:
            split = line.strip().split(',')
            if len(split) == 2:
                dots[int(split[1])][int(split[0])] = True
            elif 'x=' in split[0]:
                folds.append(('x', int(split[0].split('=')[1])))
            elif 'y=' in split[0]:
                folds.append(('y', int(split[0].split('=')[1])))

        for row in dots:
            print("".join(['#' if b else '.' for b in row]))

        fold = folds[0]
        axis = fold[0]
        number = fold[1]
        new_dots: list[list[bool]] = []

        if axis == 'x':
            new_dots = [[False for x in range(number)] for y in range(len(dots))]
            for y, row in enumerate(dots):
                for x, b in enumerate(dots):
                    if x != number:
                        new_x_coord = x
                        if x > number:
                            new_x_coord = number - (x - number)
                        new_dots[y][new_x_coord] = new_dots[y][new_x_coord] or b
        elif axis == 'y':
            new_dots = [[False for x in range(len(dots[0]))] for y in range(number)]
            for y, row in enumerate(dots):
                if y != number:
                    for x, b in enumerate(row):
                        new_y_coord = y
                        if y > number:
                            new_y_coord = number - (y - number)
                        new_dots[new_y_coord][x] = new_dots[new_y_coord][x] or b

        dots = new_dots

        for row in dots:
            print("".join(['#' if b else '.' for b in row]))

        total = 0
        for row in dots:
            for b in row:
                total += 1 if b else 0
        print(total)


if __name__ == '__main__':
    main()
