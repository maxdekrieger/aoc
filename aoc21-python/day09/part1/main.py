def main():
    with open('../data/input.txt', 'r') as file:

        heightmap: list[list[int]] = [[int(x) for x in list(line.strip())] for line in file]
        max_y = len(heightmap) - 1
        max_x = len(heightmap[0]) - 1

        lowpoints: list[int] = []

        for y, row in enumerate(heightmap):
            for x, height in enumerate(row):
                if y == max_y and x == max_x:
                    if height < heightmap[y - 1][x] and height < heightmap[y][x - 1]:
                        lowpoints.append(height)
                elif y == max_y:
                    if height < heightmap[y - 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoints.append(height)
                elif x == max_x:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x - 1]:
                        lowpoints.append(height)
                elif y == 0 and x == 0:
                    if height < heightmap[y + 1][x] and height < heightmap[y][x + 1]:
                        lowpoints.append(height)
                elif y == 0:
                    if height < heightmap[y + 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoints.append(height)
                elif x == 0:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x + 1]:
                        lowpoints.append(height)
                else:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoints.append(height)
        
        result = sum([x + 1 for x in lowpoints])
        print(result)

if __name__ == '__main__':
    main()
