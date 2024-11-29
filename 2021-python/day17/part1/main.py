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
        for possibility in range(1000):
            simulation_velocity = possibility
            simulation_y = 0
            while simulation_y >= target_y_bottom:
                simulation_y += simulation_velocity
                simulation_velocity -= 1
                if simulation_y <= target_y_top and simulation_y >= target_y_bottom:
                    possibile_y_velocities.append(possibility)
                    break

            print(f"Initial Y velocity of {possibility} possible? {possibility in possibile_y_velocities}")
        max_possible_y_velocity = max(possibile_y_velocities)
        highest_y_position = int((max_possible_y_velocity * (max_possible_y_velocity + 1)) / 2)
        print(highest_y_position)

if __name__ == '__main__':
    main()
