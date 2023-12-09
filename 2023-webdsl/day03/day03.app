application day03

  page root(){ "Hello world" }

  test part1 {
    var grid := [l.trim().split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")];
    var maxY := grid.length;
    var maxX := grid[0].length;
    var total := 0;

    for (y : Int from 0 to maxY) {
      var numberSoFar := "";
      var adjacentSymbolFound := false;
      for (x : Int from 0 to maxX) {
        if (isDigit(x, y, grid)) {
          // building number
          numberSoFar := numberSoFar + grid[y][x];

          // check whether any adjacent grid position is a symbol
          // this could be optimized because for numbers with >1 digits,
          // some grid positions are checked multiple times
          if (!adjacentSymbolFound) {
            adjacentSymbolFound := isSymbol(x-1, y-1, grid) || isSymbol(x-1, y, grid) || isSymbol(x-1, y+1, grid)
                                || isSymbol(x, y-1, grid) || isSymbol(x, y+1, grid)
                                || isSymbol(x+1, y-1, grid) || isSymbol(x+1, y, grid) || isSymbol(x+1, y+1, grid);
          }
        } else if (numberSoFar != "") {
          // number finished
          if (adjacentSymbolFound) {
            total := total + numberSoFar.parseInt();
          }
          numberSoFar := "";
          adjacentSymbolFound := false;
        }
      }
      if (numberSoFar != "") {
        // number finished
        if (adjacentSymbolFound) {
          total := total + numberSoFar.parseInt();
        }
      }
    }


    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function isSymbol(x : Int, y : Int, grid: [[String]]): Bool {
    // if x or y are out of bounds, always return false
    if (x >= grid[0].length || x < 0 || y >= grid.length || y < 0) {
      return false;
    }

    var char := grid[y][x];
    return !/[0-9]/.match(char) && char != ".";
  }

  function isDigit(x : Int, y : Int, grid: [[String]]): Bool {
    // if x or y are out of bounds, always return false
    if (x >= grid[0].length || x < 0 || y >= grid.length || y < 0) {
      return false;
    }

    return /[0-9]/.match(grid[y][x]);
  }

  test part2 {
    var grid := [l.trim().split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")];
    var maxY := grid.length;
    var maxX := grid[0].length;
    var total := 0;

    for (y : Int from 0 to maxY) {
      for (x : Int from 0 to maxX) {
        if (grid[y][x] == "*") {
          // possibly we found a gear,
          // check all adjacent coordinates for part numbers
          var adjacentParts : [Int];
          var adjacentCoordinates := adjacentCoordinates(x, y);
          while (adjacentCoordinates.length > 0) {
            // pop the first coordinate to check from the stack and de-serialize it into X and Y coords
            var coordString := adjacentCoordinates.get(0);
            adjacentCoordinates.remove(coordString);
            var coordX := coordString.split(", ")[0].parseInt();
            var coordY := coordString.split(", ")[1].parseInt();

            // if it is a digit, add the whole number it belongs to to the adjacent parts list
            if (isDigit(coordX, coordY, grid)) {
              var numberAtCoordinate := numberAtCoordinate(coordX, coordY, grid);
              adjacentParts.add(numberAtCoordinate);

              // and remove possible other parts of the number that are also in the adjacent list,
              // to avoid adding the same number twice
              var newX := coordX + 1;
              while (isDigit(newX, coordY, grid)) {
                adjacentCoordinates.remove("~newX, ~coordY");
                newX := newX + 1;
              }
            }
          }

          // it only counts as gear when there are exactly two parts adjacent
          if (adjacentParts.length == 2) {
            total := total + (adjacentParts[0] * adjacentParts[1]);
          }
        }
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function adjacentCoordinates(x : Int, y : Int): [String] {
    return ["~(x-1), ~(y-1)", "~(x), ~(y-1)", "~(x+1), ~(y-1)"
          , "~(x-1), ~(y)", "~(x+1), ~(y)"
          , "~(x-1), ~(y+1)", "~(x), ~(y+1)", "~(x+1), ~(y+1)"];
  }

  function numberAtCoordinate(x : Int, y : Int, grid : [[String]]) : Int {
    var result := grid[y][x];
    var newX := x - 1;
    while (isDigit(newX, y, grid)) {
      result := grid[y][newX] + result;
      newX := newX - 1;
    }
    newX := x + 1;
    while (isDigit(newX, y, grid)) {
      result := result + grid[y][newX];
      newX := newX + 1;
    }
    return result.parseInt();
  }
