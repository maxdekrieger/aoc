def main():
    with open('../data/input.txt', 'r') as file:

        vents: list[list[int]] = [[0 for y in range(999)] for x in range(999)]

        for i, line in enumerate(file):
            line = ','.join(line.strip().split(' -> ')).split(',')
            x1 = int(line[0])
            y1 = int(line[1])
            x2 = int(line[2])
            y2 = int(line[3])

            if x1 > x2:
                temp = x1
                x1 = x2
                x2 = temp

            if y1 > y2:
                temp = y1
                y1 = y2
                y2 = temp

            if x1 == x2:
                for i in range(y2 - y1 + 1):
                    vents[x1][y1 + i] += 1
            elif y1 == y2:
                for i in range(x2 - x1 + 1):
                    vents[x1 + i][y1] += 1

        double_vent_amount = 0
        for column in vents:
            for point in column:
                if point >= 2:
                    double_vent_amount += 1

        print('Amount of double vents: ' + str(double_vent_amount))

if __name__ == '__main__':
    main()
