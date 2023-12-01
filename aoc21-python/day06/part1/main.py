def main():
    with open('../data/input.txt', 'r') as file:

        days = 80
        state = [int(s) for s in file.readline().strip().split(',')]
        for day in range(1, days + 1):
            length = len(state)
            for i in range(length):
                if state[i] == 0:
                    state[i] = 6
                    state.append(8)
                else:
                    state[i] -= 1
            # print('Day ' + str(day) + ':\t' + str(",".join([str(x) for x in state])))
        print('Total amount after ' + str(days) + ' days: ' + str(len(state)))

if __name__ == '__main__':
    main()
