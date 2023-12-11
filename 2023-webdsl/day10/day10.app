application day10

  page root(){ "Hello world" }

  test part1 {
    var grid := [ l.trim().split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")];
    var tiles : [[Tile]];

    for (y : Int from 0 to grid.length) {
      var row : [Tile];
      for (x : Int from 0 to grid[y].length) {
        var t := Tile{ x := x, y := y, coordinate := "~x,~y", text := grid[y][x] };
        t.save();
        row.add(t);
      }
      tiles.add(row);
    }

    var start := findTileByText("S")[0];
    var current : Tile;
    if (tiles[(start.y-1)][start.x].text in ["|", "F", "7"]) {
      current := tiles[(start.y-1)][start.x];
    } else if (tiles[start.y][(start.x+1)].text in ["-", "J", "7"]) {
      current := tiles[start.y][(start.x+1)];
    } else if (tiles[(start.y+1)][start.x].text in ["|", "J", "L"]) {
      current := tiles[(start.y+1)][start.x];
    } else if (tiles[start.y][(start.x-1)].text in ["-", "F", "L"]) {
      current := tiles[start.y][(start.x-1)];
    }

    var previous := start;
    var steps := 1;
    while (current != start) {
      var next := next(current, previous, tiles);
      previous := current;
      current := next;
      steps := steps + 1;
    }

    var result := steps / 2;

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  entity Tile {
    x : Int
    y : Int
    coordinate : String
    text : String
  }

  function next(tile : Tile, previous : Tile, tiles : [[Tile]]) : Tile {
    case (tile.text) {
      "|" {
        if (previous.y < tile.y )     { return tiles[(tile.y+1)][tile.x]; }
        else if (previous.y > tile.y) { return tiles[(tile.y-1)][tile.x]; }
      }
      "-" {
        if (previous.x < tile.x )     { return tiles[tile.y][(tile.x+1)]; }
        else if (previous.x > tile.x) { return tiles[tile.y][(tile.x-1)]; }
      }
      "L" {
        if (previous.y < tile.y )     { return tiles[tile.y][(tile.x+1)]; }
        else if (previous.x > tile.x) { return tiles[(tile.y-1)][tile.x]; }
      }
      "J" {
        if (previous.y < tile.y )     { return tiles[tile.y][(tile.x-1)]; }
        else if (previous.x < tile.x) { return tiles[(tile.y-1)][tile.x]; }
      }
      "7" {
        if (previous.y > tile.y)      { return tiles[tile.y][(tile.x-1)]; }
        else if (previous.x < tile.x) { return tiles[(tile.y+1)][tile.x]; }
      }
      "F" {
        if (previous.y > tile.y)      { return tiles[tile.y][(tile.x+1)]; }
        else if (previous.x > tile.x) { return tiles[(tile.y+1)][tile.x]; }
      }
      "S" { return null; }
    }
    return null;
  }

  test part2 {
    var grid := [ l.trim().split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")];
    var tiles : [[Tile]];

    for (y : Int from 0 to grid.length) {
      var row : [Tile];
      for (x : Int from 0 to grid[y].length) {
        var t := Tile{ x := x, y := y, coordinate := "~x,~y", text := grid[y][x] };
        t.save();
        row.add(t);
      }
      tiles.add(row);
    }

    var start := findTileByText("S")[0];
    var current : Tile;
    if (tiles[(start.y-1)][start.x].text in ["|", "F", "7"]) {
      current := tiles[(start.y-1)][start.x];
    } else if (tiles[start.y][(start.x+1)].text in ["-", "J", "7"]) {
      current := tiles[start.y][(start.x+1)];
    } else if (tiles[(start.y+1)][start.x].text in ["|", "J", "L"]) {
      current := tiles[(start.y+1)][start.x];
    } else if (tiles[start.y][(start.x-1)].text in ["-", "F", "L"]) {
      current := tiles[start.y][(start.x-1)];
    }

    var previous := start;
    var loop : [Tile] := [start, current];
    while (current != start) {
      var next := next(current, previous, tiles);

      if (next != start) {
        loop.add(next);
      }

      previous := current;
      current := next;
    }

    var total := 0;
    for (y : Int from 0 to tiles.length) {
      var inside := false;
      var previousCurve := "";
      for (x : Int from 0 to tiles[0].length) {
        var t := tiles[y][x];
        if (t in loop) {
          case (t.text) {
            "|" { inside := !inside; }
            "L" { previousCurve := "L"; }
            "F" { previousCurve := "F"; }
            "S" { inside := !inside; /* by manual inspection on puzzle input, S acts as a | in my (actual) input */ }
            "J" {
              if (previousCurve == "F") { inside := !inside; } // forming an FJ curve which acts as a barrier
            }
            "7" {
              if (previousCurve == "L") { inside := !inside; } // forming an L7 curve which acts as a barrier
            }
          }
        } else if (inside) {
          total := total + 1;
        }
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }
