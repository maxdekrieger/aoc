from __future__ import annotations
from sys import maxsize

def main():
    with open('../data/input.txt', 'r') as file:

        graph: dict[tuple[int, int], Node] = {}

        length = len(file.readlines())
        file.seek(0)
        for rowcount, row in enumerate(file):
            for columncount, risk in enumerate(list(row.strip())):
                risk = int(risk)
                for repeat_row in range(5):
                    row_risk = risk + repeat_row
                    for repeat_column in range(5):
                        column_risk = row_risk + repeat_column
                        if column_risk > 9:
                            column_risk -= 9
                        graph[(rowcount + repeat_row*length, columncount + repeat_column*length)] = Node(column_risk, rowcount + repeat_row*length, columncount + repeat_column*length)

        for (rowcount, columncount), node in graph.items():
                if rowcount != 0:
                    node.addneighbour(graph[(rowcount - 1, columncount)])
                if columncount != length * 5 - 1:
                    node.addneighbour(graph[(rowcount, columncount + 1)])
                if rowcount != length * 5 - 1:
                    node.addneighbour(graph[(rowcount + 1, columncount)])
                if columncount != 0:
                    node.addneighbour(graph[(rowcount, columncount - 1)])

        unvisited = set(graph.values())
        distance: dict[Node, int] = {}
        previous: dict[Node, Node] = {}

        for node in unvisited:
            # distance[node] = maxsize
            previous[node] = None

        distance[graph[(0, 0)]] = 0
        destination = graph[(length * 5 - 1, length * 5 - 1)]
        goal = len(unvisited)
        i = 1

        while len(unvisited) > 0:
            print(f'Processing node {i}\t/\t{goal}')
            current = min(distance.items(), key=(lambda t: t[1] if t[0] in unvisited else maxsize))
            current_node = current[0]
            current_distance = current[1]
            if current_node == destination:
                print(current_distance)
                quit()
            unvisited.remove(current_node)

            for neighbour in current_node.neighbours:
                new_dist = current_distance + neighbour.risk
                if neighbour in unvisited and (neighbour not in distance or new_dist < distance[neighbour]):
                    distance[neighbour] = new_dist
                    previous[neighbour] = current_node
            del distance[current_node]
            i += 1
        print(distance[destination])

class Node:
    def __init__(self, risk: int, row, column):
        self.risk = risk
        self.row = row
        self.column = column
        self.neighbours: list[Node] = []

    def addneighbour(self, n: Node):
        self.neighbours.append(n)

if __name__ == '__main__':
    main()
