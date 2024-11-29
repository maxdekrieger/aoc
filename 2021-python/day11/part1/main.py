def main():
    with open('../data/input.txt', 'r') as file:

        steps = 100
        grid: list[list[Octopus]] = []

        for row in file:
            new_row = []
            for energy in list(row.strip()):
                new_row.append(Octopus(int(energy)))
            grid.append(new_row)
        
        max_x = len(grid[0]) - 1
        max_y = len(grid) - 1

        for y in range(max_y + 1):
            for x in range(max_x + 1):
                octopus = grid[y][x]
                if y != 0:                      octopus.add_adjacent(grid[y - 1][x])        # N
                if y != 0 and x != max_x:       octopus.add_adjacent(grid[y - 1][x + 1])    # NE
                if x != max_x:                  octopus.add_adjacent(grid[y][x + 1])        # E
                if y != max_y and x != max_x:   octopus.add_adjacent(grid[y + 1][x + 1])    # SE
                if y != max_y:                  octopus.add_adjacent(grid[y + 1][x])        # S
                if y != max_y and x != 0:       octopus.add_adjacent(grid[y + 1][x - 1])    # SW
                if x != 0:                      octopus.add_adjacent(grid[y][x - 1])        # W
                if y != 0 and x != 0:           octopus.add_adjacent(grid[y - 1][x - 1])    # NW

        total_flashes = 0

        for step in range(1, steps + 1):
            for row in grid:
                for octopus in row:
                    octopus.increase_energy()

            for row in grid:
                for octopus in row:
                    if octopus.flasing():
                        total_flashes += 1
                        octopus.reset_energy()


        print(total_flashes)

class Octopus:

    def __init__(self, energy: int):
        self.energy = energy
        self.adjacent: list[Octopus] = []
    
    def add_adjacent(self, octopus):
        self.adjacent.append(octopus)
    
    def flasing(self) -> bool:
        return self.energy == 10

    def reset_energy(self):
        self.energy = 0

    def increase_energy(self):
        if self.energy == 9:
            self.energy = 10
            for octopus in self.adjacent:
                octopus.increase_energy()
        elif self.energy != 10:
            self.energy += 1

if __name__ == '__main__':
    main()
