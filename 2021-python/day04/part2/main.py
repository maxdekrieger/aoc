def main():
    with open('../data/input.txt', 'r') as file:

        draw_numbers = None
        boards : list[dict[str, list[list[int]]]] = []

        for i, line in enumerate(file):
            line = line.strip()

            if i == 0:
                draw_numbers = [int(x) for x in line.split(',')]
            elif i % 6 == 2:
                numbers = line_to_numbers(line)
                new_board: dict[str, list[list[int]]] = {
                    "rows": [numbers],
                    "columns": [],
                }
                for x in numbers:
                    new_board["columns"].append([x])
                boards.append(new_board)
            elif line:
                idx = ceildiv(i, 6) - 1
                numbers = line_to_numbers(line)
                boards[idx]["rows"].append(numbers)
                for j, x in enumerate(numbers):
                    boards[idx]["columns"][j].append(x)

        for draw_number in draw_numbers:
            print(str(len(boards)) + ' boards left, marking ' + str(draw_number) + '...')
            completed_board = mark_numbers(boards, draw_number)
            if completed_board is not None:
                sum = 0
                for row in completed_board["rows"]:
                    for x in row:
                        sum += x
                print('Sum of unmarked: ' + str(sum))
                print('Product with drawing number: ' + str(sum * draw_number))
                return

def line_to_numbers(line: str):
    return [int(x) for x in line.split()]

def mark_numbers(boards: list[dict[str, list[list[int]]]], number: int) -> dict[str, list[list[int]]]:
    copy = boards.copy()
    for board in copy:

        board_changed = False
        for row in board["rows"]:
            if number in row:
                row.remove(number)
                board_changed = True

        for column in board["columns"]:
            if number in column:
                column.remove(number)
                board_changed = True

        if board_changed and board_completed(board):
            boards.remove(board)
            if len(boards) == 0:
                return board

    return None

def board_completed(board: dict[str, list[list[int]]]) -> bool:
    for row in board["rows"]:
        if not row:
            return True
    for column in board["columns"]:
        if not column:
            return True
    return False

def ceildiv(a, b):
    return -(a // -b)

if __name__ == '__main__':
    main()
