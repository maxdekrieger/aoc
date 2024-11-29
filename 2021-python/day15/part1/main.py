from __future__ import annotations
from sys import maxsize

def main():
    with open('../data/input.txt', 'r') as file:

        graph: dict[tuple[int, int], Node] = {}

        for rowcount, row in enumerate(file):
            for columncount, risk in enumerate(list(row.strip())):
                graph[(rowcount, columncount)] = Node(int(risk), rowcount, columncount)

        max_row = max(graph.keys(), key=(lambda k: k[0]))[0]
        max_column = max(graph.keys(), key=(lambda k: k[1]))[1]

        for (rowcount, columncount), node in graph.items():
                if rowcount != 0:
                    node.addneighbour(graph[(rowcount - 1, columncount)])
                if columncount != max_column:
                    node.addneighbour(graph[(rowcount, columncount + 1)])
                if rowcount != max_row:
                    node.addneighbour(graph[(rowcount + 1, columncount)])
                if columncount != 0:
                    node.addneighbour(graph[(rowcount, columncount - 1)])

        unvisited = set(graph.values())
        distance: dict[Node, int] = {}
        previous: dict[Node, Node] = {}

        for node in unvisited:
            distance[node] = maxsize
            previous[node] = None

        distance[graph[(0, 0)]] = 0

        while len(unvisited) > 0:
            current = min(distance.items(), key=(lambda t: t[1] if t[0] in unvisited else maxsize))
            current_node = current[0]
            current_distance = current[1]
            print(f'Processing node on row {current_node.row} and column {current_node.column}')
            unvisited.remove(current_node)

            for neighbour in current_node.neighbours:
                new_dist = current_distance + neighbour.risk
                if new_dist < distance[neighbour]:
                    distance[neighbour] = new_dist
                    previous[neighbour] = current_node
        print(distance[graph[(max_row, max_column)]])

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
