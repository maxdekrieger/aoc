from __future__ import annotations
from math import floor, ceil
import pyparsing

def main():
    with open('../data/input.txt', 'r') as file:

        thecontent = pyparsing.Word(pyparsing.nums) | ','
        parens = pyparsing.nestedExpr('[', ']', content=thecontent)
        lines: list[str] = []

        for line in file:
            lines.append(parens.parseString(line.strip()).asList()[0])
    
        best_magnitude = 0
        for i, first in enumerate(lines):
            for j, second in enumerate(lines):
                if first == second: continue
                left = SnailfishNumber(first, 0, None)
                right = SnailfishNumber(second, 0, None)
                result = reduce(addsnailfishnumbers(left, right)).magnitude()
                print(f'{i} + {j}: {result}')
                if result > best_magnitude: best_magnitude = result
        print(best_magnitude)

def addsnailfishnumbers(left: SnailfishNumber, right: SnailfishNumber):
    new_top = SnailfishNumber(left, right, -1, None)
    left.parent = new_top
    right.parent = new_top
    new_top.increasedepth()
    return new_top

def reduce(number: SnailfishNumber):
    # print(number.tostring(True))
    # print(number.tostring())
    # sec = input('')
    while number.explode() or number.split():
        # print(number.tostring(True))
        # print(number.tostring())
        # sec = input('')
        pass
    return number


class SnailfishNumber:
    def __init__(self, *args) -> None:
        self.literal = None
        self.parent: SnailfishNumber = None
        self.left = None
        self.right = None

        if isinstance(args[1], int):
            input = args[0]
            depth = args[1]
            self.parent = args[2]
            self.depth = depth

            if isinstance(input, str):
                self.literal = int(input)
            elif len(input) == 3:
                self.left = SnailfishNumber(input[0], depth + 1, self)
                self.right = SnailfishNumber(input[2], depth + 1, self)
            else:
                print(f'Unknown input: {input}')

        elif isinstance(args[0], SnailfishNumber) and isinstance(args[1], SnailfishNumber) and isinstance(args[2], int):
            self.left = args[0]
            self.right = args[1]
            self.depth = args[2]
            self.parent = args[3]

    def increasedepth(self):
        self.depth += 1
        if self.ispair():
            self.left.increasedepth()
            self.right.increasedepth()

    def tostring(self, includedepths=False):
        if self.ispair() and includedepths: return f'[{self.depth}: {self.left.tostring(includedepths)},{self.right.tostring(includedepths)}]'
        elif self.ispair(): return f'[{self.left.tostring()},{self.right.tostring()}]'
        else: return str(self.literal)

    def isliteral(self) -> bool:
        return self.literal != None

    def ispair(self) -> bool:
        return self.literal == None

    def magnitude(self) -> int:
        if self.isliteral(): return self.literal
        else: return (3 * self.left.magnitude()) + (2 * self.right.magnitude())

    def split(self) -> bool:
        if self.ispair():
            if self.left.split(): return True
            return self.right.split()
        elif self.isliteral():
            if self.literal < 10: return False
            else:
                # print(f'Splitting literal {self.literal}')
                # sec = input('')
                self.left = SnailfishNumber(str(floor(self.literal / 2)), self.depth + 1, self)
                self.right = SnailfishNumber(str(ceil(self.literal / 2)), self.depth + 1, self)
                self.literal = None
                return True

    def explode(self) -> bool:
        if self.isliteral(): return False
        elif self.ispair():
            if self.depth >= 4 and self.left.isliteral() and self.right.isliteral():
                # print(f'Exploding [{self.left.literal},{self.right.literal}]')
                # sec = input('')
                self.increaseliteralonleft(self.left.literal)
                self.increaseliteralonright(self.right.literal)
                self.left = None
                self.right = None
                self.literal = 0
                return True
            elif self.left.explode(): return True
            return self.right.explode()

    def increaseliteralonleft(self, x: int):
        one_up = self.parent
        previous = self
        impossible = False
        while one_up.left == previous:
            if one_up.parent == None:
                impossible = True
                break
            previous = one_up
            one_up = one_up.parent

        if impossible:
            # print(f'impossible to increase literal on the left :(')
            return
        checking = one_up.left
        while checking.ispair():
            checking = checking.right
        # print(f'increased literal {checking.literal} at depth {checking.depth} by {x}. result: {checking.literal + x}')
        checking.literal += x

    def increaseliteralonright(self, x: int):
        one_up = self.parent
        previous = self
        impossible = False
        while one_up.right == previous:
            if one_up.parent == None:
                impossible = True
                break
            previous = one_up
            one_up = one_up.parent

        if impossible:
            # print(f'impossible to increase literal on the right :(')
            return
        checking = one_up.right
        while checking.ispair():
            checking = checking.left
        # print(f'increased literal {checking.literal} at depth {checking.depth} by {x}. result: {checking.literal + x}')
        checking.literal += x

if __name__ == '__main__':
    main()
