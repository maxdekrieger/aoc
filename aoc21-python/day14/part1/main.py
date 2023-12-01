from sys import maxsize

def main():
    with open('../data/input.txt', 'r') as file:
        
        polymer = ''
        rules: dict[str, str] = {}
        
        for line in file:
            line = line.strip()
            if '->' not in line:
                polymer = line.strip()
            else:
                split = line.split(' -> ')
                rules[split[0]] = split[1]

        print('Polymer template:\t' + polymer)
        steps = 10

        for step in range(1, steps + 1):
            new_polymer = ''
            for i in range(len(polymer) - 1):
                new_polymer += polymer[i]
                pair = polymer[i] + polymer[i+1]
                if pair in rules:
                    new_polymer += rules[pair]
            polymer = new_polymer + polymer[len(polymer) - 1]
            print('After step ' + str(step) + ':\t\t' + polymer)

        element_counts: dict[str, int]= {}
        for e in list(polymer):
            if e not in element_counts:
                element_counts[e] = polymer.count(e)
        
        most_common = ('a', 0)
        least_common = ('a', maxsize)
        for e, c in element_counts.items():
            if c > most_common[1]: most_common = (e, c)
            if c < least_common[1]: least_common = (e, c)
        print(element_counts)
        print(str(most_common[1] - least_common[1]))


if __name__ == '__main__':
    main()
