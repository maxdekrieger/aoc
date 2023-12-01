from sys import maxsize

def main():
    with open('../data/depth-measurements.txt', 'r') as a_file:
        depth_increases = 0

        x_minus_three = None
        x_minus_two = None
        x_minus_one = None

        for line in a_file:

            line = line.strip()
            if line.isdigit():

                x = int(line)
                if x_minus_three != None and x_minus_two != None and x_minus_one != None:
                    
                    previous_sum = x_minus_three + x_minus_two + x_minus_one
                    current_sum = x_minus_two + x_minus_one + x
                    if current_sum > previous_sum:
                        depth_increases += 1

                x_minus_three = x_minus_two
                x_minus_two = x_minus_one
                x_minus_one = x

        print('Amount of depth increases: ' + str(depth_increases))

if __name__ == '__main__':
    main()
