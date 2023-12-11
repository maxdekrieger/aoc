application day11

  page root(){ "Hello world" }

  test part1 {
    var grid := [ l.split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n") ];

    // list empty rows and build galaxies + pairs
    var emptyRows : [Int];
    var galaxies : [Galaxy];
    var pairs : [Pair];
    for (y : Int from 0 to grid.length) {
      var emptyRow := true;
      for (x : Int from 0 to grid[y].length) {
        if (grid[y][x] == "#") {
          emptyRow := false;

          var new := Galaxy { x := x, y := y };
          for (g in galaxies) {
            pairs.add(Pair{ first := g, second := new });
          }
          galaxies.add(new);
        }
      }

      if (emptyRow) {
        emptyRows.add(y);
      }
    }

    // list empty columns
    var emptyColumns : [Int];
    for (i : Int from 0 to grid[0].length) {
      var emptyColumn := true;
      for (row in grid) {
        if (row[i] == "#") {
          emptyColumn := false;
        }
      }

      if (emptyColumn) {
        emptyColumns.add(i);
      }
    }

    log("There are ~galaxies.length galaxies (~pairs.length pairs)");

    var result := sum([ p.distance(emptyRows, emptyColumns, 1L) | p in pairs]);

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  entity Galaxy {
    x : Int
    y : Int
  }

  entity Pair {
    first : Galaxy
    second : Galaxy

    function distance(emptyRows : [Int], emptyColumns : [Int], expansion : Long) : Long {
      var minX := min(first.x, second.x);
      var maxX := max(first.x, second.x);
      var minY := min(first.y, second.y);
      var maxY := max(first.y, second.y);
      var addition := 0L;
      for (i : Int from minX to maxX) {
        if (i in emptyColumns) { addition := addition + expansion; }
      }
      for (i : Int from minY to maxY) {
        if (i in emptyRows) { addition := addition + expansion; }
      }

      return (maxX - minX) + (maxY - minY) + addition;
    }
  }

  function min(i : Int, j : Int) : Int {
    return if(i > j) j else i;
  }

  function max(i : Int, j : Int) : Int {
    return if(i > j) i else j;
  }

  function sum(ns: List<Long>): Long {
    var s := 0L;
    for(n: Long in ns) { s := s + n; }
    return s;
  }

  test part2 {
    var grid := [ l.split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n") ];

    // list empty rows and build galaxies + pairs
    var emptyRows : [Int];
    var galaxies : [Galaxy];
    var pairs : [Pair];
    for (y : Int from 0 to grid.length) {
      var emptyRow := true;
      for (x : Int from 0 to grid[y].length) {
        if (grid[y][x] == "#") {
          emptyRow := false;

          var new := Galaxy { x := x, y := y };
          for (g in galaxies) {
            pairs.add(Pair{ first := g, second := new });
          }
          galaxies.add(new);
        }
      }

      if (emptyRow) {
        emptyRows.add(y);
      }
    }

    // list empty columns
    var emptyColumns : [Int];
    for (i : Int from 0 to grid[0].length) {
      var emptyColumn := true;
      for (row in grid) {
        if (row[i] == "#") {
          emptyColumn := false;
        }
      }

      if (emptyColumn) {
        emptyColumns.add(i);
      }
    }

    log("There are ~galaxies.length galaxies (~pairs.length pairs)");

    var result := sum([ p.distance(emptyRows, emptyColumns, 999999L) | p in pairs]);

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }
