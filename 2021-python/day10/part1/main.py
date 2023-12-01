def main():
    with open('../data/input.txt', 'r') as file:

        opening_characters = ['(', '[', '{', '<']
        closing_characters = [')', ']', '}', '>']
        character_error_score = [3, 57, 1197, 25137]

        error_score = 0

        for i, line in enumerate(file):
            stack: list[str] = []
            print(str(i) + ': ' + line.strip())
            for character in list(line.strip()):
                if character in opening_characters:
                    stack.append(character)
                else:
                    opening_char = stack.pop()
                    opening_index = opening_characters.index(opening_char)
                    closing_index = closing_characters.index(character)
                    if closing_index != opening_index:
                        error_score += character_error_score[closing_index]
        print(error_score)

if __name__ == '__main__':
    main()
