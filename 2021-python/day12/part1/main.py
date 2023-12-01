from __future__ import annotations

def main():
    with open('../data/input.txt', 'r') as file:
        
        system: dict[str, Cave] = {}

        for line in file:
            split = line.strip().split('-')
            start = split[0]
            end = split[1]

            if start not in system:
                system[start] = Cave(start)
            if end not in system:
                system[end] = Cave(end)
            
            system[start].addconnected(system[end])
            system[end].addconnected(system[start])

        for name, cave in system.items():
            print(name + ': ' + ",".join([c.name for c in cave.connected]))

        print('')
        paths = system['start'].paths([system['start']])
        for path in paths:
            print(",".join([cave.name for cave in path]))
        print(len(paths))

class Cave:
    def __init__(self, name: str):
        self.name = name
        self.big: bool = name.isupper()
        self.connected: list[Cave] = []

    def addconnected(self, c: Cave):
        self.connected.append(c)

    def paths(self, path_so_far: list[Cave]) -> list[list[Cave]]:
        # print('trying new path: on cave ' + self.name + ', path so far: ' + "".join([c.name for c in path_so_far]))

        if self.name == 'end':
            return [path_so_far]

        paths: list[list[Cave]] = []
        for cave in self.connected:
            if (cave not in path_so_far) or cave.big:
                new_path = path_so_far.copy()
                new_path.append(cave)
                new_paths = cave.paths(new_path)
                paths.extend(new_paths)
        return paths


if __name__ == '__main__':
    main()
