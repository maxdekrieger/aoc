from itertools import product

def main():
    with open('../data/input.txt', 'r') as file:
        line = file.read().strip().split(',')
        x_part = line[0].split('..')
        target_x_start = int(x_part[0].split('x=')[1])
        target_x_end = int(x_part[1])
        y_part = line[1].split('..')
        target_y_bottom = int(y_part[0].split('y=')[1])
        target_y_top = int(y_part[1])
        print(f"target: x={target_x_start}..{target_x_end}, y={target_y_bottom}..{target_y_top}")

        # figure out possible x velocities
        possible_x_velocities = [target_x_end]
        for possibility in range(1, target_x_end + 1):
            simulation_velocity = possibility
            simulation_x = 0
            while simulation_x <= target_x_end and simulation_velocity > 0:
                simulation_x += simulation_velocity
                simulation_velocity -= 1
                if simulation_x >= target_x_start and simulation_x <= target_x_end:
                    possible_x_velocities.append(possibility)
                    break
        
        possibile_y_velocities = []
        for possibility in range(target_y_bottom, abs(target_y_bottom) + 10):
            simulation_velocity = possibility
            simulation_y = 0
            while simulation_y >= target_y_bottom:
                simulation_y += simulation_velocity
                simulation_velocity -= 1
                if simulation_y <= target_y_top and simulation_y >= target_y_bottom:
                    possibile_y_velocities.append(possibility)
                    break

        possibilities: set[tuple[int, int]] = set([])
        for x_velocity, y_velocity in product(possible_x_velocities, possibile_y_velocities):
            simulation_x = 0
            simulation_y = 0
            simulation_x_velocity = x_velocity
            simulation_y_velocity = y_velocity
            while simulation_x <= target_x_end and simulation_y >= target_y_bottom:
                simulation_x += simulation_x_velocity
                simulation_y += simulation_y_velocity
                if simulation_x_velocity > 0: simulation_x_velocity -= 1
                simulation_y_velocity -= 1
                if (simulation_x >= target_x_start and simulation_x <= target_x_end) and (simulation_y <= target_y_top and simulation_y >= target_y_bottom):
                    possibilities.add((x_velocity, y_velocity))
                    break
        print(len(possibilities))
if __name__ == '__main__':
    main()
