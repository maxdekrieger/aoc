from __future__ import annotations
from collections import defaultdict

input = '../data/input.txt'

def main():
    with open(input, 'r') as file:
        lines = file.readlines()
        copies: dict[tuple[bool, int, int, int, int], int] = defaultdict(lambda: 0)
        copies[(True, 0, int(lines[0].split(': ')[1].strip()), 0, int(lines[1].split(': ')[1].strip()))] += 1
        
        still_playing = True
        while still_playing:
            still_playing = False
            new_copies: dict[tuple[bool, int, int, int, int], int] = defaultdict(lambda: 0)
            
            for (p1_turn, p1_score, p1_pos, p2_score, p2_pos), amount in copies.items():
                if p1_score < 21 and p2_score < 21:
                    still_playing = True
                    for first_roll in range(1,4):
                        for second_roll in range(1,4):
                            for third_roll in range(1,4):
                                roll = first_roll + second_roll + third_roll
                                if p1_turn:
                                    p1_new_pos = p1_pos + roll
                                    while p1_new_pos > 10: p1_new_pos -= 10
                                    p1_new_score = p1_score + p1_new_pos
                                    new_copies[(False, p1_new_score, p1_new_pos, p2_score, p2_pos)] += amount
                                else:
                                    p2_new_pos = p2_pos + roll
                                    while p2_new_pos > 10: p2_new_pos -= 10
                                    p2_new_score = p2_score + p2_new_pos
                                    new_copies[(True, p1_score, p1_pos, p2_new_score, p2_new_pos)] += amount
                else:
                    new_copies[(p1_turn, p1_score, p1_pos, p2_score, p2_pos)] += amount
            copies = new_copies
        p1_won = 0
        p2_won = 0
        for (_, p1_score, _, p2_score, _), amount in copies.items():
            if p1_score >= 21:
                p1_won += amount
            elif p2_score >= 21:
                p2_won += amount
            else:
                print(f'Error: no one won: p1 score was {p1_score}, p2 score was {p2_score}')

        print(f'p1 won {p1_won} times{" (MOST)" if p1_won > p2_won else ""}')
        print(f'p2 won {p2_won} times{" (MOST)" if p2_won > p1_won else ""}')


if __name__ == '__main__':
    main()
