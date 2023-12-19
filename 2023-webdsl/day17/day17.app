application day17

  page root(){ "Hello world" }

  test part1 {
    var gridString := [ l.split() | l in "../aoc-input/example-input-part1.txt".pathToFile().getContentAsString().trim().split("\n")];
    var grid : [[[CityBlock]]];
    var toVisit : [CityBlock];

    // build layout
    for (y : Int from 0 to gridString.length) {
      var rowString := gridString[y];
      var row : [[CityBlock]];
      for (x : Int from 0 to rowString.length) {
        var nextDirections : [CityBlock];
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := up, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := right, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := down, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := left, totalCost := 2147483647});
        row.add(nextDirections);
        toVisit.addAll(nextDirections);
      }
      grid.add(row);
    }

    grid[0][0][directionToInt(right)].totalCost := 0;
    grid[0][0][directionToInt(down)].totalCost := 0;
    while (toVisit.length > 0) {
      var u := toVisit[0]; toVisit.removeAt(0);

      for (v in u.neighbours(grid)) {
        var alt := u.totalCost + v.costSum;
        if (alt < v.totalCost) {
          v.totalCost := alt;
          v.prev := u;
        }
      }

      toVisit := [v | v in toVisit order by v.totalCost asc];
    }

    var line := [[ cb | cb in grid[grid.length - 1][grid.length - 1] order by cb.totalCost asc ][0]];
    var cur := line[0];
    while (!(cur in grid[0][0])) {
      cur := cur.prev;
      line.add(cur);
    }

    // for (r in grid) {
    //   var row := "";
    //   for (c in r) {
    //     row := row + (if (c[0] in line || c[1] in line || c[2] in line || c[3] in line) "\033[1m~(c[0].costToEnter)\033[0m" else c[0].costToEnter.toString());
    //   }
    //   log(row);
    // }

    var leastHeatLoss := line[0].totalCost;

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(leastHeatLoss);
    log("-----------------------------------------------------");
  }

  entity CityBlock {
    x : Int
    y : Int
    costToEnter : Int
    costSum : Int
    nextDirection : Direction

    totalCost : Int
    prev : CityBlock

    function neighbours(grid : [[[CityBlock]]]) : [CityBlock] {
      var result : [CityBlock];

      case (nextDirection) {
        up {
          for (i : Int from 0 to 3) {
            if (y > i) {
              result.add(grid[y-(i+1)][x][directionToInt(left)]);
              result.add(grid[y-(i+1)][x][directionToInt(right)]);
            }
          }
        }
        down {
          for (i : Int from 1 to 4) {
            if (y < grid.length - i) {
              result.add(grid[y+i][x][directionToInt(left)]);
              result.add(grid[y+i][x][directionToInt(right)]);
            }
          }
        }
        left {
          for (i : Int from 0 to 3) {
            if (x > i) {
              result.add(grid[y][x-(i+1)][directionToInt(up)]);
              result.add(grid[y][x-(i+1)][directionToInt(down)]);
            }
          }
        }
        right {
          for (i : Int from 1 to 4) {
            if (x < grid[y].length - i) {
              result.add(grid[y][x+i][directionToInt(up)]);
              result.add(grid[y][x+i][directionToInt(down)]);
            }
          }
        }
      }

      for (i : Int from 0 to result.length) {
        if (i < 2) {
          result[i].costSum := result[i].costToEnter;
        } else if (i < 4) {
          result[i].costSum := result[i].costToEnter + result[0].costToEnter;
        } else if (i < 6) {
          result[i].costSum := result[i].costToEnter + result[2].costToEnter + result[0].costToEnter;
        }
      }

      return result;
    }

    function neighboursPart2(grid : [[[CityBlock]]]) : [CityBlock] {
      var result : [CityBlock];

      case (nextDirection) {
        up {
          for (i : Int from 0 to 10) {
            if (y > i) {
              result.add(grid[y-(i+1)][x][directionToInt(left)]);
              result.add(grid[y-(i+1)][x][directionToInt(right)]);
            }
          }
        }
        down {
          for (i : Int from 1 to 11) {
            if (y < grid.length - i) {
              result.add(grid[y+i][x][directionToInt(left)]);
              result.add(grid[y+i][x][directionToInt(right)]);
            }
          }
        }
        left {
          for (i : Int from 0 to 10) {
            if (x > i) {
              result.add(grid[y][x-(i+1)][directionToInt(up)]);
              result.add(grid[y][x-(i+1)][directionToInt(down)]);
            }
          }
        }
        right {
          for (i : Int from 1 to 11) {
            if (x < grid[y].length - i) {
              result.add(grid[y][x+i][directionToInt(up)]);
              result.add(grid[y][x+i][directionToInt(down)]);
            }
          }
        }
      }

      for (i : Int from 0 to result.length) {
        if (i < 2) {
          result[i].costSum := result[i].costToEnter;
        } else if (i < 4) {
          result[i].costSum := result[i].costToEnter + result[0].costToEnter;
        } else if (i < 6) {
          result[i].costSum := result[i].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 8) {
          result[i].costSum := result[i].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 10) {
          result[i].costSum := result[i].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 12) {
          result[i].costSum := result[i].costToEnter + result[8].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 14) {
          result[i].costSum := result[i].costToEnter + result[10].costToEnter + result[8].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 16) {
          result[i].costSum := result[i].costToEnter + result[12].costToEnter + result[10].costToEnter + result[8].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 18) {
          result[i].costSum := result[i].costToEnter + result[14].costToEnter + result[12].costToEnter + result[10].costToEnter + result[8].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        } else if (i < 20) {
          result[i].costSum := result[i].costToEnter + result[16].costToEnter + result[14].costToEnter + result[12].costToEnter + result[10].costToEnter + result[8].costToEnter + result[6].costToEnter + result[4].costToEnter + result[2].costToEnter + result[0].costToEnter;
        }
      }

      for (i : Int from 0 to 6) {
        if (result.length > 0) {
          result.removeAt(0);
        }
      }

      return result;
    }
  }

  enum Direction {
    up("Up"),
    right("Right"),
    down("Down"),
    left("Left")
  }

  function directionToInt(dir : Direction) : Int {
    case (dir) {
      up    { return 0; }
      right { return 1; }
      down  { return 2; }
      left  { return 3; }
    }

    return -1;
  }

  test part2 {
    var gridString := [ l.split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")];
    var grid : [[[CityBlock]]];
    var toVisit : [CityBlock];

    // build layout
    for (y : Int from 0 to gridString.length) {
      var rowString := gridString[y];
      var row : [[CityBlock]];
      for (x : Int from 0 to rowString.length) {
        var nextDirections : [CityBlock];
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := up, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := right, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := down, totalCost := 2147483647});
        nextDirections.add(CityBlock{ costToEnter := gridString[y][x].parseInt(), x := x, y := y, nextDirection := left, totalCost := 2147483647});
        row.add(nextDirections);
        toVisit.addAll(nextDirections);
      }
      grid.add(row);
    }

    grid[0][0][directionToInt(right)].totalCost := 0;
    grid[0][0][directionToInt(down)].totalCost := 0;
    while (toVisit.length > 0) {
      var u := toVisit[0]; toVisit.removeAt(0);

      var neighbours := u.neighboursPart2(grid);
      // log("neighbours of (~u.x,~u.y): " + [ "(~n.x,~n.y, ~n.costSum)" | n in neighbours ].concat(", "));
      for (v in neighbours) {
        var alt := u.totalCost + v.costSum;
        if (alt < v.totalCost) {
          v.totalCost := alt;
          v.prev := u;
        }
      }

      toVisit := [v | v in toVisit order by v.totalCost asc];
    }

    var line := [[ cb | cb in grid[grid.length - 1][grid.length - 1] order by cb.totalCost asc ][0]];
    var cur := line[0];
    while (!(cur in grid[0][0])) {
      cur := cur.prev;
      line.add(cur);
    }

    for (r in grid) {
      var row := "";
      for (c in r) {
        row := row + (if (c[0] in line || c[1] in line || c[2] in line || c[3] in line) "\033[1m~(c[0].costToEnter)\033[0m" else c[0].costToEnter.toString());
      }
      log(row);
    }

    var leastHeatLoss := line[0].totalCost;

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(leastHeatLoss);
    log("-----------------------------------------------------");
  }
