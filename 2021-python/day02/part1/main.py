def main():
    with open('../data/instructions.txt', 'r') as a_file:
        horizontal = 0
        depth = 0

        for line in a_file:
            
            parts = line.split()
            if len(parts) == 2 and parts[1].isdigit():
                if parts[0] == 'forward':
                    horizontal += int(parts[1])
                elif parts[0] == 'down':
                    depth += int(parts[1])
                elif parts[0] == 'up':
                    depth -= int(parts[1])

        print("Horizontal: " + str(horizontal) +  ", Depth: " + str(depth))
        print("Product of depth and horizontal movement: " + str(horizontal * depth))

if __name__ == '__main__':
    main()
