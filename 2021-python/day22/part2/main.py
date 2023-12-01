from __future__ import annotations
from collections import defaultdict

input = '../data/input.txt'

def main():
    with open(input, 'r') as file:

        instructions: list[tuple[int, bool, int, int, int, int, int, int]] = []
        overlaps_with: dict[int, list[int]] = defaultdict(lambda: [])

        for i, line in enumerate(file):
            line = line.strip().split(" ")
            b = line[0] == "on"
            instruction = line[1].split(",")
            instruction = list(map(lambda x: x[2:].split(".."), instruction))
            x_start = int(instruction[0][0])
            x_end = int(instruction[0][1])
            y_start = int(instruction[1][0])
            y_end = int(instruction[1][1])
            z_start = int(instruction[2][0])
            z_end = int(instruction[2][1])
            bounds = (x_start, x_end, y_start, y_end, z_start, z_end)

            # print(f'Processing instruction {i}: {line[0]} x={x_start}..{x_end}, y={y_start}..{y_end}, z={z_start}..{z_end}')
            
            for n, n_b, n_x_start, n_x_end, n_y_start, n_y_end, n_z_start, n_z_end in instructions:
                relevant_area = to_relevant_area((n_x_start, n_x_end, n_y_start, n_y_end, n_z_start, n_z_end), bounds)
                if not is_overlapping(relevant_area, bounds):
                    continue

                (n_x_start, n_x_end, n_y_start, n_y_end, n_z_start, n_z_end) = relevant_area
                # print(f'\tPrevious instruction {n} ({n_b}) is relevant in the following area: x={n_x_start}..{n_x_end}, y={n_y_start}..{n_y_end}, z={n_z_start}..{n_z_end}')
                overlaps_with[i].append(n)              

            instructions.append((i, b, x_start, x_end, y_start, y_end, z_start, z_end))

        active = active_reactors_in_area(instructions, (-10000000, 10000000, -10000000, 10000000, -10000000, 10000000))
        print(active)

def active_reactors_in_area(original_instructions: list[tuple[int, bool, int, int, int, int, int, int]], area: tuple[int, int, int, int, int, int]) -> int:
    # print(f'{original_instructions}, {area}')
    if len(original_instructions) == 0: return 0
    instructions = original_instructions.copy()
    instruction = instructions.pop()
    i = instruction[0]
    b = instruction[1]
    on_off = 'on' if b else 'off'
    relevant_instruction_area = to_relevant_area(instruction[2:], area)
    if not is_overlapping(relevant_instruction_area, area): return active_reactors_in_area(instructions, area)
    relevant_instruction_area_size = ((relevant_instruction_area[1] + 1 - relevant_instruction_area[0]) * (relevant_instruction_area[3] + 1 - relevant_instruction_area[2]) * (relevant_instruction_area[5] + 1 - relevant_instruction_area[4]))

    active = active_reactors_in_area(instructions, area)
    active_in_relevant_instruction_area = active_reactors_in_area(instructions, relevant_instruction_area)
    # print(f'Processing instruction {i} ({on_off}) in area {area}...')
    # print(f'\tRelevant area: {relevant_instruction_area}...')
    # print(f'\tTotal active until now: {active}')
    # print(f'\tActive in relevant instruction area: {active_in_relevant_instruction_area}')
    if b:
        new_on = relevant_instruction_area_size - active_in_relevant_instruction_area
        # print(f'\tReactors turned on: {new_on}')
        active += new_on
    else:
        new_off = min(active_in_relevant_instruction_area, relevant_instruction_area_size)
        # print(f'\tReactors turned off: {new_off}')
        active -= new_off
    return active

def to_relevant_area(original: tuple[int, int, int, int, int, int], bounds: tuple[int, int, int, int, int, int]) -> tuple[int, int, int, int, int, int]:
    (result_x_start, result_x_end, result_y_start, result_y_end, result_z_start, result_z_end) = original
    (x_start, x_end, y_start, y_end, z_start, z_end) = bounds

    if result_x_start < x_start and result_x_end >= x_start: result_x_start = x_start
    if result_x_start <= x_end and result_x_end > x_end: result_x_end = x_end
    if result_y_start < y_start and result_y_end >= y_start: result_y_start = y_start
    if result_y_start <= y_end and result_y_end > y_end: result_y_end = y_end
    if result_z_start < z_start and result_z_end >= z_start: result_z_start = z_start
    if result_z_start <= z_end and result_z_end > z_end: result_z_end = z_end

    result = (result_x_start, result_x_end, result_y_start, result_y_end, result_z_start, result_z_end)

    return result

def is_overlapping(possible_overlapping_area, relevant_area) -> bool:
    (n_x_start, n_x_end, n_y_start, n_y_end, n_z_start, n_z_end) = possible_overlapping_area
    (x_start, x_end, y_start, y_end, z_start, z_end) = relevant_area

    if n_x_start < x_start or n_x_end > x_end or n_y_start < y_start or n_y_end > y_end or n_z_start < z_start or n_z_end > z_end:
        return False

    return True

if __name__ == '__main__':
    main()
