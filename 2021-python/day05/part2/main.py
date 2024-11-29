def main():
    with open('../data/input.txt', 'r') as file:

        vents: list[list[int]] = [[0 for y in range(1000)] for x in range(1000)]

        for i, line in enumerate(file):
            line = ','.join(line.strip().split(' -> ')).split(',')
            x1 = int(line[0])
            y1 = int(line[1])
            x2 = int(line[2])
            y2 = int(line[3])

            # possible swap to reduce amount of cases
            if (x1 > x2 and y1 > y2) or (x2 > x1 and y1 > y2):
                temp = x1
                x1 = x2
                x2 = temp
                temp = y1
                y1 = y2
                y2 = temp
            elif (x1 == x2) and (y1 > y2):
                temp = y1
                y1 = y2
                y2 = temp
            elif (y1 == y2) and (x1 > x2):
                temp = x1
                x1 = x2
                x2 = temp

            if x1 == x2:
                for j in range(y2 - y1 + 1):
                    vents[x1][y1 + j] += 1
            elif y1 == y2:
                for j in range(x2 - x1 + 1):
                    vents[x1 + j][y1] += 1
            elif x2 > x1 and y2 > y1:
                for j in range(x2 - x1 + 1):
                    vents[x1 + j][y1 + j] += 1
            elif x1 > x2 and y2 > y1:
                for j in range(x1 - x2 + 1):
                    vents[x1 - j][y1 + j] += 1


        double_vent_amount = 0
        for column in vents:
            for point in column:
                if point >= 2:
                    double_vent_amount += 1

        print('Amount of double vents: ' + str(double_vent_amount))

if __name__ == '__main__':
    main()
