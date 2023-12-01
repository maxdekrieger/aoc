from __future__ import annotations
from collections import defaultdict

input = '../data/input.txt'

def main():
    with open(input, 'r') as file:

        grid: dict[int, dict[int, dict[int, bool]]] = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: False)))

        for line in file:
            line = line.strip().split(" ")
            b = line[0] == "on"
            instruction = line[1].split(",")
            instruction = list(map(lambda x: x[2:].split(".."), instruction))
            x_start = int(instruction[0][0])
            x_end = int(instruction[0][1])
            y_start = int(instruction[1][0])
            y_end = int(instruction[1][1])
            z_start = int(instruction[2][0])
            z_end = int(instruction[2][1])

            if x_start < -50 and x_end >= -50: x_start = -50
            if x_start <= 50 and x_end > 50: x_end = 50
            if y_start < -50 and y_end >= -50: y_start = -50
            if y_start <= 50 and y_end > 50: y_end = 50
            if z_start < -50 and z_end >= -50: z_start = -50
            if z_start <= 50 and z_end > 50: z_end = 50

            print(f'{x_start}..{x_end}, {y_start}..{y_end}, {z_start}..{z_end}')
            if (x_start < -50 or x_end > 50 or y_start < -50 or y_end > 50 or z_start < -50 or z_end > 50):
                print('SKIPPED')
                continue

            for x in range(x_start, x_end + 1):
                for y in range(y_start, y_end + 1):
                    for z in range(z_start, z_end + 1):
                        grid[x][y][z] = b

        on = 0
        for x, plane in grid.items():
            for y, row in plane.items():
                for z, b in row.items():
                    if b: on += 1
        print(on)

if __name__ == '__main__':
    main()
