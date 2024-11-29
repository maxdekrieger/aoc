def main():
    with open('../data/input.txt', 'r') as file:

        correct_zero = {'a', 'b',  'c',  'e',  'f',  'g'}
        correct_one = {'c', 'f'}
        correct_two = {'a', 'c', 'd', 'e', 'g'}
        correct_three = {'a', 'c', 'd', 'f', 'g'}
        correct_four = {'b', 'c', 'd',  'f'}
        correct_five = {'a', 'b', 'd', 'f', 'g'}
        correct_six = {'a', 'b', 'd', 'e', 'f', 'g'}
        correct_seven = {'a', 'c', 'f'}
        correct_eight = {'a', 'b', 'c', 'd', 'e', 'f', 'g'}
        correct_nine = {'a', 'b', 'c', 'd', 'f', 'g'}

        sum = 0

        for line in file:
            line = line.strip().split(' | ')
            input_patterns = [list(pattern) for pattern in sorted(line[0].split(' '), key=len)]
            output_patterns = [list(pattern) for pattern in line[1].split(' ')]

            original_mapping = {
                'a': list(set(input_patterns[1]) - set(input_patterns[0]))[0],
                'b': None,
                'c': None,
                'd': None,
                'e': None,
                'f': None,
                'g': None,
            }

            # C and F
            c_and_f = input_patterns[0]
            zero_not_present = 0
            one_not_present = 0
            for pattern in input_patterns:
                if len(pattern) == len(set(pattern) - set([c_and_f[0]])): zero_not_present += 1
                if len(pattern) > len(set(pattern) - set([c_and_f[1]])): one_not_present += 1

            if zero_not_present == 1:
                original_mapping['f'] = c_and_f[0]
                original_mapping['c'] = c_and_f[1]
            else:
                original_mapping['f'] = c_and_f[1]
                original_mapping['c'] = c_and_f[0]

            # B
            zero_six_nine_four = list(filter(lambda p: len(p) == 6, input_patterns))
            zero_six_nine_four.append(input_patterns[2])
            zero_six_nine_four_without_f = list(map(lambda p: set(p) - set(original_mapping['f']), zero_six_nine_four))
            original_mapping['b'] = list(zero_six_nine_four_without_f[0].intersection(zero_six_nine_four_without_f[1], zero_six_nine_four_without_f[2], zero_six_nine_four_without_f[3]))[0]

            # G
            zero_six_nine = list(filter(lambda p: len(p) == 6, input_patterns))
            abf = set([original_mapping['a'], original_mapping['b'], original_mapping['f']])
            zero_six_nine_without_abf = list(map(lambda p: set(p) - abf, zero_six_nine))
            original_mapping['g'] = list(zero_six_nine_without_abf[0].intersection(zero_six_nine_without_abf[1], zero_six_nine_without_abf[2]))[0]

            # D
            original_mapping['d'] = list(set(input_patterns[2]) - set([original_mapping['b'], original_mapping['c'], original_mapping['f']]))[0]

            # E
            original_mapping['e'] = list(set(input_patterns[9]) - set([original_mapping['a'], original_mapping['b'], original_mapping['c'], original_mapping['d'], original_mapping['f'], original_mapping['g']]))[0]

            seen_values: set[str] = set([])
            for k, v in original_mapping.items():
                if v in seen_values:
                    print('DOUBLE OCCURRENCE OF ' + v + ' (key: ' + k + ')')
                    print(original_mapping)
                    return
                seen_values.add(v)

            mapping = {v: k for k, v in original_mapping.items()}
            # print(mapping)
            number = []
            for pattern in output_patterns:
                mapped = set(map(lambda p: mapping[p], pattern))
                if mapped == correct_zero: number.append('0')
                elif mapped == correct_one: number.append('1')
                elif mapped == correct_two: number.append('2')
                elif mapped == correct_three: number.append('3')
                elif mapped == correct_four: number.append('4')
                elif mapped == correct_five: number.append('5')
                elif mapped == correct_six: number.append('6')
                elif mapped == correct_seven: number.append('7')
                elif mapped == correct_eight: number.append('8')
                elif mapped == correct_nine: number.append('9')

            number = "".join(number)
            print('Number: ' + number)

            sum += int(number)

        print(sum)

if __name__ == '__main__':
    main()
