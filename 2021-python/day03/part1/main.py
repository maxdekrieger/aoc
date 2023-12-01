def main():
    with open('../data/input.txt', 'r') as file:

        total_lines = 0
        initialized = False
        bitcount = []

        for line_untrimmed in file:
            line = line_untrimmed.strip()
            total_lines += 1

            if initialized:
                for i, bitstr in enumerate(list(line)):
                    bitcount[i] += int(bitstr)
            else:
                initialized = True
                for bitstr in list(line):
                    bitcount.append(int(bitstr))

        print("Total lines: " + str(total_lines))
        print("Bitcount: " + str(bitcount))

        gamma_rate_binary = []
        epsilon_rate_binary = []
        for count in bitcount:
            gamma_bit = 1 if (count > (total_lines - count)) else 0
            gamma_rate_binary.append(gamma_bit)
            epsilon_rate_binary.append(1 - gamma_bit)

        gamma_rate = int("".join([str(bit) for bit in gamma_rate_binary]), 2)
        epsilon_rate = int("".join([str(bit) for bit in epsilon_rate_binary]), 2)

        print("Gamma Rate: Binary " + str(gamma_rate_binary) + ", Decimal " + str(gamma_rate))
        print("Epsilon Rate: Binary " + str(epsilon_rate_binary) + ", Decimal " + str(epsilon_rate))
        print("Product: " + str(gamma_rate * epsilon_rate))

if __name__ == '__main__':
    main()
