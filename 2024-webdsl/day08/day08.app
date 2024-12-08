application day08

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var maxY := input.length - 1;
    var maxX := input[0].trim().split().length;

    // group antennas based on frequency
    var antennas : [(String, Int, Int)];

    // fill antenna groups
    for( y from 0 to input.length ){
      var row := input[y].trim().split();
      for( x from 0 to row.length ){
        if( row[x] != "." ){
          antennas.add( (row[x], x, y) );
        }
      }
    }

    var antinodes : [[Bool]] := [ [ false | x in input[0].trim().split() ] | y in input ];

    for( a in antennas ){
      var x := a.second as Int;
      var y := a.third as Int;
      for( other in antennas where a.first == other.first && a != other ){
        var otherX := other.second as Int;
        var otherY := other.third as Int;
        var xDiff := otherX - x;
        var yDiff := otherY - y;
        var antinodeX := otherX + xDiff;
        var antinodeY := otherY + yDiff;

        if( antinodeY >= 0 && antinodeY <= maxY && antinodeX >= 0 && antinodeX <= maxX ){
          antinodes[antinodeY][antinodeX] := true;
        }
      }
    }

    var result := sum([ [ b | b in row where b ].length | row in antinodes ]);

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var maxY := input.length - 1;
    var maxX := input[0].trim().split().length - 1;

    // group antennas based on frequency
    var antennas : [(String, Int, Int)];

    // fill antenna groups
    for( y from 0 to input.length ){
      var row := input[y].trim().split();
      for( x from 0 to row.length ){
        if( row[x] != "." ){
          antennas.add( (row[x], x, y) );
        }
      }
    }

    var antinodes : [[Bool]] := [ [ false | x in input[0].trim().split() ] | y in input ];

    for( a in antennas ){
      var x := a.second as Int;
      var y := a.third as Int;
      for( other in antennas where a.first == other.first && a != other ){
        var otherX := other.second as Int;
        var otherY := other.third as Int;
        var xDiff := otherX - x;
        var yDiff := otherY - y;

        var multiplier := 0;
        var antinodeX := otherX + multiplier * xDiff;
        var antinodeY := otherY + multiplier * yDiff;
        while( antinodeY >= 0 && antinodeY <= maxY && antinodeX >= 0 && antinodeX <= maxX ){
          antinodes[antinodeY][antinodeX] := true;

          multiplier := multiplier + 1;
          antinodeX := otherX + multiplier * xDiff;
          antinodeY := otherY + multiplier * yDiff;
        }
      }
    }

    var result := sum([ [ b | b in row where b ].length | row in antinodes ]);

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function sum(ns: [Int]): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }

  function printGrid( input : [String], antinodes: [[Bool]] ){
    for( y from 0 to input.length ){
      var row := input[y].trim().split();
      var log := "";
      for( x from 0 to row.length ){
        if( row[x] != "." ){
          log := log + row[x];
        } else if( antinodes[y][x] ){
          log := log + "#";
        } else{
          log := log + ".";
        }
      }
      log(log);
    }
  }
