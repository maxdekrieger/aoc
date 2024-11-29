application day16

  page root(){ "Hello world" }

  test part1 {
    var gridString := [ l.split() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")];
    var grid : [[Tile]];

    // build layout
    for (y : Int from 0 to gridString.length) {
      var rowString := gridString[y];
      var row : [Tile];
      for (x : Int from 0 to rowString.length) {
        row.add(Tile{
          text := gridString[y][x]
          x := x
          y := y
          energized := false
        });
      }
      grid.add(row);
    }

    // use list as queue
    var queue := [ TileInQueue{previous := grid[0][0], tile := t} | t in grid[0][0].next(-1, 0, grid)];
    while(queue.length > 0) {
      var t := queue[0]; queue.removeAt(0);
      var tTileNext := t.tile.next(t.previous.x, t.previous.y, grid);
      queue.addAll([ TileInQueue{previous := t.tile, tile := next} | next in tTileNext]);
    }

    var energized := 0;
    for (r in grid) {
      for (t in r) {
        if (t.energized) { energized := energized + 1; }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(energized);
    log("-----------------------------------------------------");
  }

  entity Tile {
    text : String
    x : Int
    y : Int

    energized : Bool
    processedIncomingDirections : [Direction] (transient)

    // determines the next tile(s) the beam goes to
    function next(fromX : Int, fromY : Int, grid : [[Tile]]) : [Tile] {
      var result : [Tile];
      var direction := incomingDirection(fromX, fromY, x, y);

      if (direction in processedIncomingDirections) { return result; }
      case (text) {
        "." {
          result.addAll(tileInGrid(x, y, direction, grid));
        }
        "/" {
          case (direction) {
            up    { result.addAll(tileInGrid(x, y, right, grid)); }
            right { result.addAll(tileInGrid(x, y, up, grid)); }
            down  { result.addAll(tileInGrid(x, y, left, grid)); }
            left  { result.addAll(tileInGrid(x, y, down, grid)); }
          }
        }
        "\\" {
          case (direction) {
            up    { result.addAll(tileInGrid(x, y, left, grid)); }
            right { result.addAll(tileInGrid(x, y, down, grid)); }
            down  { result.addAll(tileInGrid(x, y, right, grid)); }
            left  { result.addAll(tileInGrid(x, y, up, grid)); }
          }
        }
        "|" {
          if (direction == left || direction == right) {
            result.addAll(tileInGrid(x, y, up, grid));
            result.addAll(tileInGrid(x, y, down, grid));
          } else {
            result.addAll(tileInGrid(x, y, direction, grid));
          }
        }
        "-" {
          if (direction == up || direction == down) {
            result.addAll(tileInGrid(x, y, left, grid));
            result.addAll(tileInGrid(x, y, right, grid));
          } else {
            result.addAll(tileInGrid(x, y, direction, grid));
          }
        }
      }

      energized := true;
      processedIncomingDirections.add(direction);

      return result;
    }

    function reset() {
      energized := false;
      processedIncomingDirections.clear();
    }
  }

  function incomingDirection(fromX : Int, fromY : Int, toX : Int, toY : Int) : Direction {
    if (fromY < toY) { return down; }
    if (fromX < toX) { return right; }
    if (fromY > toY) { return up; }
    if (fromX > toX) { return left; }
    return null;
  }

  enum Direction {
    up("Up"),
    right("Right"),
    down("Down"),
    left("Left")
  }

  function tileInGrid(x : Int, y : Int, direction : Direction, grid : [[Tile]]) : [Tile] {
    var result : [Tile];
    var height := grid.length - 1;
    var width := grid[0].length - 1;

    case (direction) {
      up    { if (y > 0) { result.add(grid[(y-1)][x]); } }
      right { if (x < width) { result.add(grid[y][(x+1)]); } }
      down  { if (y < height) { result.add(grid[(y+1)][x]); } }
      left  { if (x > 0) { result.add(grid[y][(x-1)]);  } }
    }

    return result;
  }

  // tuple workaround
  entity TileInQueue {
    previous : Tile
    tile : Tile
  }

  test part2 {
    var gridString := [ l.split() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")];
    var grid : [[Tile]];

    // build layout
    for (y : Int from 0 to gridString.length) {
      var rowString := gridString[y];
      var row : [Tile];
      for (x : Int from 0 to rowString.length) {
        row.add(Tile{
          text := gridString[y][x]
          x := x
          y := y
          energized := false
        });
      }
      grid.add(row);
    }

    var maxEnergized := 0;

    // left and right side
    for (y : Int from 0 to grid.length) {
      // left
      var energized := energizedTiles([ TileInQueue{previous := grid[y][0], tile := t} | t in grid[y][0].next(-1, y, grid)], grid);
      maxEnergized := max(maxEnergized, energized);

      // reset
      for (r in grid) { for (t in r) { t.reset(); } }

      // right
      energized := energizedTiles([ TileInQueue{previous := grid[y][(grid[0].length-1)], tile := t} | t in grid[y][(grid[0].length-1)].next(grid[0].length, y, grid)], grid);
      maxEnergized := max(maxEnergized, energized);

      // reset
      for (r in grid) { for (t in r) { t.reset(); } }
    }

    // top and bottom
    for (x : Int from 0 to grid[0].length) {
      // top
      var energized := energizedTiles([ TileInQueue{previous := grid[0][x], tile := t} | t in grid[0][x].next(x, -1, grid)], grid);
      maxEnergized := max(maxEnergized, energized);

      // reset
      for (r in grid) { for (t in r) { t.reset(); } }

      // bottom
      energized := energizedTiles([ TileInQueue{previous := grid[(grid.length-1)][x], tile := t} | t in grid[(grid.length-1)][x].next(x, grid.length, grid)], grid);
      maxEnergized := max(maxEnergized, energized);

      // reset
      for (r in grid) { for (t in r) { t.reset(); } }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(maxEnergized);
    log("-----------------------------------------------------");
  }

  function energizedTiles(startingStack : [TileInQueue], grid : [[Tile]]) : Int {
    var queue := startingStack;
    while(queue.length > 0) {
      // get first item in queue
      var t := queue[0]; queue.removeAt(0);
      var tTileNext := t.tile.next(t.previous.x, t.previous.y, grid);
      queue.addAll([ TileInQueue{previous := t.tile, tile := next} | next in tTileNext]);
    }

    var energized := 0;
    for (r in grid) {
      for (t in r) {
        if (t.energized) { energized := energized + 1; }
      }
    }

    return energized;
  }

  function max(i : Int, j : Int) : Int {
    return if (i > j) i else j;
  }
