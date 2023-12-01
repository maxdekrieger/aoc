from __future__ import annotations

packet_counter = 0

def main():
    with open('../data/input.txt', 'r') as file:
        hex = list(file.read().strip())
        print(hex)
        binary = "".join([bin(int(hexchar, 16))[2:].zfill(4) for hexchar in hex])
        packet = Packet(None, binary)
        print(f'Sum of versions: {packet.version_sum()}')
        print(f'Value: {packet.value()}')

class Packet:
    def __init__(self, parent: Packet, binstr: str):
        self.id = freshid()

        self.parent = parent
        self.bin = binstr
        self.version = int(self.bin[:3], 2)
        self.type = int(self.bin[3:6], 2)
        self.length = 6
        self.subpackets: list[Packet] = []

        if self.type == 4:
            literal_tuple = packet_bin_to_literal(self.bin[6:])
            self.literal = literal_tuple[0]
            self.length += literal_tuple[1]
            print(f'id: {self.id}, parent.id: {None if not parent else self.parent.id}, version: {self.version}, type: {self.type}, literal: {self.literal}')
        else:
            subpackets_tuple = packet_bin_to_subpackets(self, self.bin[6:])
            self.subpackets = subpackets_tuple[0]
            self.length += subpackets_tuple[1]
            print(f'id: {self.id}, parent.id: {None if not parent else self.parent.id}, version: {self.version}, type: {self.type}, amount of subpackets: {len(self.subpackets)}')

    def version_sum(self) -> int:
        return self.version + sum([sub.version_sum() for sub in self.subpackets])

    def value(self) -> int:
        if self.type == 0:
            return sum([p.value() for p in self.subpackets])
        elif self.type == 1:
            result = 1
            for p in self.subpackets:
                result = result * p.value()
            return result
        elif self.type == 2:
            return min([p.value() for p in self.subpackets])
        elif self.type == 3:
            return max([p.value() for p in self.subpackets])
        elif self.type == 4:
            return self.literal
        elif self.type == 5:
            return 1 if self.subpackets[0].value() > self.subpackets[1].value() else 0
        elif self.type == 6:
            return 1 if self.subpackets[0].value() < self.subpackets[1].value() else 0
        elif self.type == 7:
            return 1 if self.subpackets[0].value() == self.subpackets[1].value() else 0

def freshid() -> int:
    global packet_counter
    packet_counter += 1
    return packet_counter

def packet_bin_to_subpackets(parent : Packet, binstr: str) -> tuple[list[Packet], int]:
    result = []
    length_type_id = int(binstr[0], 2)
    total_length = 1
    if length_type_id == 0:
        subpacket_total_length = int(binstr[1:16], 2)
        total_length += 15
        used_subpackets_length = 0
        while used_subpackets_length < subpacket_total_length:
            subpacket = Packet(parent, binstr[16 + used_subpackets_length:])
            result.append(subpacket)
            used_subpackets_length += subpacket.length
        total_length += used_subpackets_length
    else:
        total_number_of_subpackets = int(binstr[1:12], 2)
        total_length += 11
        used_subpackets_length = 0
        while len(result) < total_number_of_subpackets:
            subpacket = Packet(parent, binstr[12 + used_subpackets_length:])
            result.append(subpacket)
            used_subpackets_length += subpacket.length
        total_length += used_subpackets_length

    return (result, total_length)

def packet_bin_to_literal(binstr: str) -> tuple[int, int]:
    remaining = binstr
    literal_binary = ''
    used_length = 0
    while remaining[0] == '1':
        literal_binary += remaining[1:5]
        remaining = remaining[5:]
        used_length += 5
    literal_binary += remaining[1:5]
    used_length += 5
    return (int(literal_binary, 2), used_length)

if __name__ == '__main__':
    main()
