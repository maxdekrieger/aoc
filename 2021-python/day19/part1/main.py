from __future__ import annotations

overlapping_scanners: dict[int, dict[int, tuple[int, int, int, int]]] = {}

def main():
    with open('../data/input.txt', 'r') as file:
        unique_points: list[tuple[int, int, int]] = []
        scanner_points: list[list[tuple[int, int, int]]] = []

        # {scanner: [(other_scanner, orientation_relative_to_other, relative_x, relative_y, relative_z)]}
        # overlapping_scanners: dict[int, list[tuple[int, int, int, int, int]]] = {}

        current_scanner_points: list[tuple[int, int, int]] = []
        for line in file:
            line = line.strip()
            if line.startswith("--- scanner"):
                scanner_points.append(current_scanner_points)
                current_scanner_points = []
            else:
                split = line.split(',')
                if len(split) == 3:
                    current_scanner_points.append((int(split[0]), int(split[1]), int(split[2])))
        scanner_points.append(current_scanner_points)
        scanner_points = scanner_points[1:]

        # add all points from scanner 0
        unique_points.extend(scanner_points[0])

        for i, new_scanner in enumerate(scanner_points):
            overlapping_scanners[i] = {}
            new_scanner_points_orientations: list[list[tuple[int,int,int]]] = [
                [   (x,y,z),    (x,z,-y),   (x,-y,-z),  (x,-z,y),
                    (-x,-y,z),  (-x,z,y),   (-x,y,-z),  (-x,-z,-y),
                    (y,z,x),    (y,x,-z),   (y,-z,-x),  (y,-x,-z),
                    (-y,-z,x),  (-y,x,z),   (-y,z,-x),  (-y,-x,-z),
                    (z,x,y),    (z,y,-x),   (z,-x,-y),  (z,-y,x),
                    (-z,-x,y),  (-z,y,x),   (-z,x,-y),  (-z,-y,-x)
                ] for (x,y,z) in new_scanner
            ]
            for j, second_scanner in enumerate(scanner_points):
                if i == j:
                    print(f'Progress: i={i}\tj={j} SKIPPING')
                    continue
                if i > j and (i not in overlapping_scanners[j]):
                    print(f'Progress: i={i}\tj={j} SKIPPING')
                    continue
                print(f'Progress: i={i}\tj={j}')
                found_overlap = False
                for orientation in range(24):
                    if found_overlap: break
                    for p1 in range(len(new_scanner_points_orientations)):
                        if found_overlap: break
                        marker_point = new_scanner_points_orientations[p1][orientation]
                        for assumption_point in second_scanner:
                            if found_overlap: break
                            x_diff = marker_point[0] - assumption_point[0]
                            y_diff = marker_point[1] - assumption_point[1]
                            z_diff = marker_point[2] - assumption_point[2]
                            overlapping_amount = 0
                            for p2 in range(len(new_scanner_points_orientations)):
                                new_scanner_point = new_scanner_points_orientations[p2][orientation]
                                for second_scanner_point in second_scanner:
                                    if new_scanner_point[0] - x_diff == second_scanner_point[0] and new_scanner_point[1] - y_diff == second_scanner_point[1] and new_scanner_point[2] - z_diff == second_scanner_point[2]:
                                        overlapping_amount += 1
                            if overlapping_amount >= 12:
                                found_overlap = True
                                overlapping_scanners[i][j] = (orientation, x_diff, y_diff, z_diff)
                                break

        print('DONE FINDING OVERLAPS!')
        for i, overlaps in overlapping_scanners.items():
            for j in overlaps.keys():
                print(f'{i} overlaps with {j}')

        scanners: list[Scanner] = [Scanner(i, scanner_points[i]) for i in range(len(scanner_points))]
        left_to_map = set(range(1, len(scanners)))
        while len(left_to_map) > 0:
            for i in range(len(scanners)):
                for j in overlapping_scanners[i].keys():
                    if i not in left_to_map and j in left_to_map and i in overlapping_scanners[j].keys():
                        scanners[j].chain = scanners[i].chain.copy()
                        scanners[j].chain.append(scanners[i])
                        left_to_map.remove(j)
                        break

        for s in scanners:
            print(f'Scanner {s.id} chain: {[x.id for x in s.chain]}')

        beacons = set([])
        for s in scanners:
            s.transform()
            beacons = beacons.union(s.beacons)

        print(len(beacons))

class Scanner:
    def __init__(self, id, beacons) -> None:
        self.id = id
        self.chain: list[Scanner] = []
        self.next: list[Scanner] = []
        self.beacons: list[tuple[int, int, int]] = beacons

    def transform(self) -> bool:
        base = self.id
        while len(self.chain) > 0:
            target = self.chain.pop().id
            (_, x_diff, y_diff, z_diff) = overlapping_scanners[target][base]
            (orientation, _, _, _) = overlapping_scanners[base][target]
            print(f'Transforming scanner {self.id}. Orientation: {orientation}, relative distances: {(x_diff, y_diff, z_diff)}')
            # print(overlapping_scanners[base][target])
            # print(overlapping_scanners[target][base])
            self.beacons = list(map(lambda p: (p[0] + x_diff, p[1] + y_diff, p[2] + z_diff), self.beacons))
            self.beacons = list(map(lambda p: changeorientation(orientation, p), self.beacons))
            base = target
        print(f'Done transforming scanner {self.id}. Beacons: ')
        for beacon in self.beacons:
            print(f'\t{beacon[0]},\t{beacon[1]},\t{beacon[2]}')
        print('')

def changeorientation(orientation, point: tuple[int, int, int]) -> tuple[int, int, int]:
    x,y,z = point
    return [
            (x,y,z),    (x,z,-y),   (x,-y,-z),  (x,-z,y),
            (-x,-y,z),  (-x,z,y),   (-x,y,-z),  (-x,-z,-y),
            (y,z,x),    (y,x,-z),   (y,-z,-x),  (y,-x,-z),
            (-y,-z,x),  (-y,x,z),   (-y,z,-x),  (-y,-x,-z),
            (z,x,y),    (z,y,-x),   (z,-x,-y),  (z,-y,x),
            (-z,-x,y),  (-z,y,x),   (-z,x,-y),  (-z,-y,-x)
        ][orientation]

if __name__ == '__main__':
    main()
