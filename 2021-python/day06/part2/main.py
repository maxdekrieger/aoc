def main():
    with open('../data/input.txt', 'r') as file:

        days = 256
        cycle = range(9)
        input = [int(s) for s in file.readline().strip().split(',')]

        days_left_state = [0 for x in cycle]
        for x in input:
            days_left_state[x] += 1

        print('Initial amount:\t' + str(sum(days_left_state)))

        for day in range(1, days + 1):
            new_days_left_state = [0 for x in cycle]
            
            new_days_left_state[0] = days_left_state[1]
            new_days_left_state[1] = days_left_state[2]
            new_days_left_state[2] = days_left_state[3]
            new_days_left_state[3] = days_left_state[4]
            new_days_left_state[4] = days_left_state[5]
            new_days_left_state[5] = days_left_state[6]
            new_days_left_state[6] = days_left_state[7] + days_left_state[0]
            new_days_left_state[7] = days_left_state[8]
            new_days_left_state[8] = days_left_state[0]

            days_left_state = new_days_left_state
            print('Amount after ' + str(day) + ' days:\t' + str(sum(days_left_state)))

if __name__ == '__main__':
    main()
