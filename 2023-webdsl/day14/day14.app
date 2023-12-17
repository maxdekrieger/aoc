application day14

  page root(){ "Hello world" }

  test part1 {
    var grid := [ l.trim().split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n") ];

    performTilt(grid);

    var total := 0;
    for (i : Int from 0 to grid.length) {
      var weight := grid.length - i;
      total := total + weight * [ c | c in grid[i] where c == "O"].length;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function performTilt(grid : [[String]]) {
    for (y : Int from 1 to grid.length) {
      for (x : Int from 0 to grid[0].length) {
        if (grid[y][x] == "O" && grid[(y-1)][x] == ".") {
          var newY := y-1;
          while (newY > 0 && grid[(newY-1)][x] == ".") {
            newY := newY - 1;
          }
          grid[newY].set(x, "O");
          grid[y].set(x, ".");
        }
      }
    }
  }

  test part2 {
    var grid := [ l.trim().split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n") ];

    var from : [String];
    var to : [[[String]]];
    var from1000 : [String];
    var to1000 : [[[String]]];

    for (i : Int from 0 to 1000000) {
      var gridString := [r.concat() | r in grid].concat();
      var index := from1000.indexOf(gridString);
      if (index != -1) {
        grid := to1000[index];
      } else {
        from1000.add(gridString);
        for (j : Int from 0 to 1000) {
          gridString := [r.concat() | r in grid].concat();
          index := from.indexOf(gridString);
          if (index != -1) {
            grid := to[index];
          } else {
            from.add(gridString);
            grid := performCycle(grid);
            to.add(grid);
          }
        }
        to1000.add(grid);
        log("Adding new entry at cycle " + (i+1)*1000);
      }
    }

    var total := 0;
    for (i : Int from 0 to grid.length) {
      var weight := grid.length - i;
      total := total + weight * [ c | c in grid[i] where c == "O"].length;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function performCycle(grid : [[String]]) : [[String]] {
    var result := grid;
    performTilt(result); // north

    result := rotate90Clockwise(result);
    performTilt(result); // west

    result := rotate90Clockwise(result);
    performTilt(result); // south

    result := rotate90Clockwise(result);
    performTilt(result); // east

    result := rotate90Clockwise(result);
    return result;
  }

  function rotate90Clockwise(grid : [[String]]) : [[String]] {
    var newGrid : [[String]];
    var length := grid.length; // assuming it is square

    for (y : Int from 0 to length) {
      var newRow : [String];
      for (x : Int from 0 to length) {
        newRow.add( grid[(length - 1 - x)][y] );
      }
      newGrid.add(newRow);
    }

    return newGrid;
  }
