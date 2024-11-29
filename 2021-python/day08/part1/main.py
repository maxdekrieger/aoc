def main():
    with open('../data/input.txt', 'r') as file:

        simple_digit_occurrence = 0
        unique_segment_amounts = [2, 4, 3, 7]

        for line in file:
            line = line.strip()
            output = line.split(' | ')[1]
            patterns = output.split(' ')
            for pattern in patterns:
                if len(pattern) in unique_segment_amounts:
                    simple_digit_occurrence += 1

        print(simple_digit_occurrence)

if __name__ == '__main__':
    main()
