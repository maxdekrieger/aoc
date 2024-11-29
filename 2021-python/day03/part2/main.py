def main():
    with open('../data/input.txt', 'r') as file:

        oxygen_options  : list[list[int]] = []
        co2_options     : list[list[int]] = []

        first_bit_one_amount = 0

        for i, line in enumerate(file):
            line = line.strip()
            oxygen_options.append([int(b) for b in list(line)])
            co2_options.append([int(b) for b in list(line)])
            first_bit_one_amount += oxygen_options[i][0]

        oxygen_options = pruneOptions(oxygen_options, 0, 1 if (first_bit_one_amount >= len(oxygen_options) - first_bit_one_amount) else 0)
        co2_options = pruneOptions(co2_options, 0, 1 if (first_bit_one_amount < len(co2_options) - first_bit_one_amount) else 0)

        line_length = len(oxygen_options[0]) - 1

        oxygen_result = None
        current_index = 1
        while oxygen_result == None:
            if len(oxygen_options) == 1:
                oxygen_result = int("".join([str(b) for b in oxygen_options[0]]), 2)
            elif current_index > line_length:
                oxygen_result = "WTF"
                print(str(oxygen_options))
            else:
                first_bit_one_amount = 0
                for option in oxygen_options:
                    first_bit_one_amount += option[current_index]
                oxygen_options = pruneOptions(oxygen_options, current_index, 1 if (first_bit_one_amount >= len(oxygen_options) - first_bit_one_amount) else 0)
                current_index += 1

        co2_result = None
        current_index = 1
        while co2_result == None:
            if len(co2_options) == 1:
                co2_result = int("".join([str(b) for b in co2_options[0]]), 2)
            elif current_index > line_length:
                co2_result = "WTF"
                print(str(co2_options))
            else:
                first_bit_one_amount = 0
                for option in co2_options:
                    first_bit_one_amount += option[current_index]
                co2_options = pruneOptions(co2_options, current_index, 1 if (first_bit_one_amount < len(co2_options) - first_bit_one_amount) else 0)
                current_index += 1
        
        print("Oxygen result: " + str(oxygen_result))
        print("CO2 result: " + str(co2_result))
        print("Product: " + str(oxygen_result * co2_result))

def pruneOptions(list: list[list[int]], index: int, required: int) -> list[list[int]]:
    result = []

    for option in list:
        if option[index] == required:
            result.append(option)

    return result

if __name__ == '__main__':
    main()
