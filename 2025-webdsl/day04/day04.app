application day04

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var grid := [ [ s | s in row.trim().split() ] | row in input ];

    var accessibleRolls := 0;
    for( y : Int from 0 to grid.length ){
      for( x : Int from 0 to grid[y].length ){
        if( grid[y][x] == "@"){
          var numberOfAdjacentRolls := [ r | r in [ grid[a.second as Int][a.first as Int] == "@" | a in adjacentPositions( x, y, grid ) ] where r == true].length;
          if( numberOfAdjacentRolls < 4){
            accessibleRolls := accessibleRolls + 1;
          }
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(accessibleRolls);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var grid := [ [ s | s in row.trim().split() ] | row in input ];

    var removedRollsTotal := 0;
    var rollsToRemove := [(-1,-1)];
    while( rollsToRemove.length > 0 ){
      rollsToRemove := List<(Int, Int)>();
      for( y : Int from 0 to grid.length ){
        for( x : Int from 0 to grid[y].length ){
          if( grid[y][x] == "@"){
            var numberOfAdjacentRolls := [ r | r in [ grid[a.second as Int][a.first as Int] == "@" | a in adjacentPositions( x, y, grid ) ] where r == true].length;
            if( numberOfAdjacentRolls < 4){
              rollsToRemove.add((x, y));
            }
          }
        }
      }
      for( rollToRemove in rollsToRemove ){
        grid[rollToRemove.second as Int].set(rollToRemove.first as Int, ".");
        removedRollsTotal := removedRollsTotal + 1;
      }
      log("Removed ~rollsToRemove.length rolls this iteration (~removedRollsTotal total)");
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(removedRollsTotal);
    log("-----------------------------------------------------");
  }

  function adjacentPositions( x : Int, y : Int, grid : [[String]] ) : [(Int, Int)] {
    var result := List<(Int, Int)>();

    for( d : Direction in (from Direction) ){
      var c := nextCoordinate( (x, y), d );
      if( isInBounds( c.first as Int, c.second as Int, grid ) ){
        result.add(c);
      }
    }

    return result;
  }

  function isInBounds( x : Int, y : Int, grid : [[String]] ) : Bool {
    return x >= 0 && y >= 0 && y < grid.length && x < grid[y].length;
  }

  enum Direction{
    North("N"),
    NorthEast("NE"),
    East("E"),
    SouthEast("SE"),
    South("S"),
    SouthWest("SW"),
    West("W"),
    NorthWest("NW")
  }

  function nextCoordinate( c : (Int, Int), d : Direction ) : (Int, Int) {
    var x := c.first as Int;
    var y := c.second as Int;

    case(d){
      North     { y := y - 1; }
      NorthEast { y := y - 1; x := x + 1; }
      East      { x := x + 1; }
      SouthEast { y := y + 1; x := x + 1; }
      South     { y := y + 1; }
      SouthWest { y := y + 1; x := x - 1; }
      West      { x := x - 1; }
      NorthWest { y := y - 1; x := x - 1; }
    }

    return (x, y);
  }