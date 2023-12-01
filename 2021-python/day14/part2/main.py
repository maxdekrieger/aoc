from collections import defaultdict

def main():
    with open('../data/input.txt', 'r') as file:

        pair_counts: dict[str, int] = defaultdict(lambda: 0)
        char_counts: dict[str, int] = defaultdict(lambda: 0)
        rules: dict[str, str] = {}

        for line in file:
            line = line.strip()
            if '->' not in line:
                polymer = line.strip()
                for i in range(len(polymer) - 1):
                    pair_counts[polymer[i] + polymer[i+1]] += 1
                    char_counts[polymer[i]] += 1
                char_counts[polymer[len(polymer) - 1]] += 1
            else:
                split = line.split(' -> ')
                rules[split[0]] = split[1]

        print(pair_counts)
        print(char_counts)

        steps = 40
        most_char = 'a'
        least_char = 'a'

        for step in range(steps):
            new_pair_counts = defaultdict(lambda: 0)
            for key, value in pair_counts.items():
                new_char = rules[key]
                first_pair = key[0] + new_char
                second_pair = new_char + key[1]
                new_pair_counts[first_pair] += value
                new_pair_counts[second_pair] += value
                char_counts[new_char] += value
            pair_counts = new_pair_counts
            most_char = max(char_counts.keys(), key=(lambda k: char_counts[k]))
            least_char = min(char_counts.keys(), key=(lambda k: char_counts[k]))
            print(f"")
            print(f"Done with step {step + 1}")
            print(f"most char: {most_char}: {char_counts[most_char]}")
            print(f"least char: {least_char}: {char_counts[least_char]}")
            print(f"result: {char_counts[most_char]} - {char_counts[least_char]} = {char_counts[most_char] - char_counts[least_char]}")


if __name__ == '__main__':
    main()
