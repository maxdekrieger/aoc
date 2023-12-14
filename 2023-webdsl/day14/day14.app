application day14

  page root(){ "Hello world" }

  test part1 {
    var grid := [ l.trim().split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n") ];

    var stepPerformed := true;
    while (stepPerformed) {
      stepPerformed := false;
      for (y : Int from 1 to grid.length) {
        for (x : Int from 0 to grid[0].length) {
          if (grid[y][x] == "O" && grid[(y-1)][x] == ".") {
            grid[(y-1)].set(x, "O");
            grid[y].set(x, ".");
            stepPerformed := true;
          }
        }
      }
    }

    var total := 0;
    for (i : Int from 0 to grid.length) {
      var weight := grid.length - i;
      total := total + weight * [ c | c in grid[i] where c == "O"].length;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    for( l in "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      //
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log("");
    log("-----------------------------------------------------");
  }
