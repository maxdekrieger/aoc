from sys import maxsize

def main():
    with open('../data/depth-measurements.txt', 'r') as a_file:
        depth_increases = 0
        last_measurement = maxsize
        for line in a_file:
            line = line.strip()
            if line.isdigit():
                x = int(line)
                if x > last_measurement:
                    depth_increases += 1
                last_measurement = x
        print('Amount of depth increases: ' + str(depth_increases))

if __name__ == '__main__':
    main()
