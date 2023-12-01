def main():
    with open('../data/input.txt', 'r') as file:

        heightmap: list[list[int]] = [[int(x) for x in list(line.strip())] for line in file]
        max_y = len(heightmap) - 1
        max_x = len(heightmap[0]) - 1

        lowpoint_coords: list[tuple] = []

        for y, row in enumerate(heightmap):
            for x, height in enumerate(row):
                if y == max_y and x == max_x:
                    if height < heightmap[y - 1][x] and height < heightmap[y][x - 1]:
                        lowpoint_coords.append((x, y))
                elif y == max_y:
                    if height < heightmap[y - 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoint_coords.append((x, y))
                elif x == max_x:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x - 1]:
                        lowpoint_coords.append((x, y))
                elif y == 0 and x == 0:
                    if height < heightmap[y + 1][x] and height < heightmap[y][x + 1]:
                        lowpoint_coords.append((x, y))
                elif y == 0:
                    if height < heightmap[y + 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoint_coords.append((x, y))
                elif x == 0:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x + 1]:
                        lowpoint_coords.append((x, y))
                else:
                    if height < heightmap[y - 1][x] and height < heightmap[y + 1][x] and height < heightmap[y][x - 1] and height < heightmap[y][x + 1]:
                        lowpoint_coords.append((x, y))
        
        basins: list[list[tuple[int, int]]] = []
        for lowpoint_x, lowpoint_y in lowpoint_coords:
            lowpoint_basin = [(lowpoint_x, lowpoint_y)]
            print('lowpoint: ' + str((lowpoint_x, lowpoint_y)))
            points_to_check: list[tuple[int, int]] = get_new_adjacent_coordinates(lowpoint_x, lowpoint_y, max_x, max_y, lowpoint_basin)
            while len(points_to_check) > 0:
                x,y = points_to_check.pop(0)
                
                if heightmap[y][x] != 9 and (x,y) not in lowpoint_basin:
                    lowpoint_basin.append((x,y))
                    points_to_check.extend(get_new_adjacent_coordinates(x, y, max_x, max_y, lowpoint_basin))

            basins.append(lowpoint_basin)
            print('basin: ' + str(len(lowpoint_basin)))
            print('')
        basins = sorted(basins, key=len)
        basins.reverse()
        result = len(basins[0]) * len(basins[1]) * len(basins[2])
        print(result)

            
def get_new_adjacent_coordinates(start_x, start_y, max_x, max_y, basin: list[tuple]) -> list[tuple]:
    adjacents = [(start_x, start_y - 1), (start_x + 1, start_y), (start_x, start_y + 1), (start_x - 1, start_y)]
    result = []
    
    for x, y in adjacents:
        if x >= 0 and x <= max_x and y >= 0 and y <= max_y and (x, y) not in basin:
            result.append((x, y))

    return result

if __name__ == '__main__':
    main()
