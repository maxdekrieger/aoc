from __future__ import annotations

input = '../data/input.txt'

def main():
    with open(input, 'r') as file:
        lines = file.readlines()
        p1_score = 0
        p1_pos = int(lines[0].split(': ')[1].strip())
        p2_score = 0
        p2_pos = int(lines[1].split(': ')[1].strip())
        dice_position = 1
        dice_rolls = 0

        p1_turn = True

        while p1_score < 1000 and p2_score < 1000:
            update = 0
            for i in range(3):
                dice_rolls += 1
                update += dice_position
                dice_position += 1
                if dice_position > 100: dice_position -= 100

            if p1_turn:
                p1_pos += update
                while p1_pos > 10: p1_pos -= 10
                p1_score += p1_pos
            else:
                p2_pos += update
                while p2_pos > 10: p2_pos -= 10
                p2_score += p2_pos
            p1_turn = not p1_turn
        
        if p1_score >= 1000:
            print(dice_rolls * p2_score)
        else:
            print(dice_rolls * p1_score)


if __name__ == '__main__':
    main()
