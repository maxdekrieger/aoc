application day06

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var obstacleGrid := [ [ tile == "#" | tile in row.trim().split() ] | row in input ];
    var visited := [ [ false | tile in row where tile == tile ] | row in obstacleGrid ]; // where tile == tile is nonsensical but just a workaround for unused variable warning

    var y := input.indexOf([ r | r in input where r.contains("^") ][0]);
    var x := input[y].split().indexOf("^");
    var d := North;
    visited[y][x] := true;

    // continue traversing the map as long as we're not out of bounds
    var next := nextCoordinate((x, y), d);
    var nextX := next.first as Int;
    var nextY := next.second as Int;
    while( nextY >= 0 && nextY < obstacleGrid.length && nextX >=0 && nextX < obstacleGrid[nextY].length ){

      // when facing an obstacle, turn right 90 degrees and try again next iteration
      if( obstacleGrid[nextY][nextX] ){
        d := turnRight90Degrees(d);
      } else{ // when facing an empty tile, mark as visited and move there
        x := nextX;
        y := nextY;
        visited[y][x] := true;
      }

      next := nextCoordinate((x, y), d);
      nextX := next.first as Int;
      nextY := next.second as Int;
    }

    var result := sum([ [ b | b in row where b ].length | row in visited ]);

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var obstacleGrid := [ [ tile == "#" | tile in row.trim().split() ] | row in input ];
    var loopObstacles := [ [ false | tile in row where tile == tile ] | row in obstacleGrid ]; // where tile == tile is nonsensical but just a workaround for unused variable warning

    // keep track of where we have been, and what direction we were facing on that tile
    var visited := [ [ List<Direction>() | tile in row where tile == tile ] | row in obstacleGrid ]; // where tile == tile is nonsensical but just a workaround for unused variable warning

    var y := input.indexOf([ r | r in input where r.contains("^") ][0]);
    var x := input[y].split().indexOf("^");
    var d := North;
    visited[y][x].add(d);

    // continue traversing the map as long as we're not out of bounds
    var next := nextCoordinate((x, y), d);
    var nextX := next.first as Int;
    var nextY := next.second as Int;
    while( nextY >= 0 && nextY < obstacleGrid.length && nextX >=0 && nextX < obstacleGrid[nextY].length ){

      // when facing an obstacle, turn right 90 degrees and try again next iteration
      if( obstacleGrid[nextY][nextX] ){
        d := turnRight90Degrees(d);
      } else{ // when facing an empty tile

        // if there would be an obstacle on the next tile that would cause us to turn, and we end up in a loop,
        // mark that as new obstacle that would cause a loop
        obstacleGrid[nextY].set(nextX, true);
        if( visited[nextY][nextX].length == 0 && turnEndsInLoop(x, y, d, obstacleGrid, visited) ){
          loopObstacles[nextY][nextX] := true;
        }
        obstacleGrid[nextY].set(nextX, false);

        // mark as visited in current direction and move there
        x := nextX;
        y := nextY;
        visited[y][x].add(d);
      }

      next := nextCoordinate((x, y), d);
      nextX := next.first as Int;
      nextY := next.second as Int;
    }

    var result := sum([ [ b | b in row where b ].length | row in loopObstacles ]);

    // for( i from 0 to obstacleGrid.length ){
    //   var log := "";
    //   for ( j from 0 to obstacleGrid[i].length ){
    //     if( obstacleGrid[i][j] ){
    //       log := log + "#";
    //     } else if ( loopObstacles[i][j] ){
    //       log := log + "O";
    //     } else {
    //       log := log + ".";
    //     }
    //   }
    //   log(log);
    // }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  enum Direction{
    North("N"),
    East("E"),
    South("S"),
    West("W")
  }

  function turnRight90Degrees( d : Direction ) : Direction {
    var result := d;
    case(d){
      North { result := East; }
      East  { result := South; }
      South { result := West; }
      West  { result := North; }
    }
    return result;
  }

  function nextCoordinate( c : (Int, Int), d : Direction ) : (Int, Int) {
    // construct coordinate to check
    var x := c.first as Int;
    var y := c.second as Int;

    case(d){
      North { y := y - 1; }
      East  { x := x + 1; }
      South { y := y + 1; }
      West  { x := x - 1; }
    }

    return (x, y);
  }

  function sum(ns: [Int]): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }

  function turnEndsInLoop( currentX : Int, currentY : Int, currentDirection : Direction, obstacleGrid : [[Bool]], visited : [[[Direction]]] ) : Bool {
    var virtualVisited := [ [ [ d | d in tile ] | tile in row ] | row in visited ]; // clone original list
    var x := currentX;
    var y := currentY;
    var d := turnRight90Degrees(currentDirection);

    var next := nextCoordinate((x, y), d);
    var nextX := next.first as Int;
    var nextY := next.second as Int;
    while( nextY >= 0 && nextY < obstacleGrid.length && nextX >=0 && nextX < obstacleGrid[nextY].length ){

      // when facing an obstacle, turn right 90 degrees and try again next iteration
      if( obstacleGrid[nextY][nextX]){
        d := turnRight90Degrees(d);
      } else{ // when facing an empty tile

        // if you have already been on the next tile in the same direction, this is a loop
        if( virtualVisited[nextY][nextX].indexOf( d ) >= 0 ){
          return true;
        }

        // mark as visited in current direction and move there
        x := nextX;
        y := nextY;
        virtualVisited[y][x].add(d);
      }

      next := nextCoordinate((x, y), d);
      nextX := next.first as Int;
      nextY := next.second as Int;
    }

    return false;
  }
