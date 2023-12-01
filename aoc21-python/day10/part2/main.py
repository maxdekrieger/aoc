from os import error


def main():
    with open('../data/input.txt', 'r') as file:

        opening_characters = ['(', '[', '{', '<']
        closing_characters = [')', ']', '}', '>']
        character_error_score = [1, 2, 3, 4]

        error_scores = []

        for i, line in enumerate(file):
            
            stack: list[str] = []
            illegal = False
            print(str(i) + ': ' + line.strip())
            
            for character in list(line.strip()):
                if character in opening_characters:
                    stack.append(character)
                else:
                    opening_char = stack.pop()
                    opening_index = opening_characters.index(opening_char)
                    closing_index = closing_characters.index(character)
                    if closing_index != opening_index:
                        illegal = True
                        break
            
            if not illegal:
                score = 0
                while len(stack) > 0:
                    character = stack.pop()
                    score = score * 5 + character_error_score[opening_characters.index(character)]
                print(score)
                error_scores.append(score)
        print(sorted(error_scores)[len(error_scores) // 2])

if __name__ == '__main__':
    main()
