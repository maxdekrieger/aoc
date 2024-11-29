from sys import maxsize

def main():
    with open('../data/input.txt', 'r') as file:

        original_positions = [int(s) for s in file.readline().strip().split(',')]
        highest = max(original_positions)
        lowest = min(original_positions)

        lowest_fuel_cost = maxsize
        for target in range(lowest, highest + 1):
            fuel = 0
            for pos in original_positions:
                required = abs(target - pos)
                fuel += required * (required + 1) / 2
            lowest_fuel_cost = fuel if fuel < lowest_fuel_cost else lowest_fuel_cost 

        print(lowest_fuel_cost)

if __name__ == '__main__':
    main()
