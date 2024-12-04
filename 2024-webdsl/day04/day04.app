application day04

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var grid := [ row.trim().split() | row in input ];

    var xmasCount := 0;
    for( y : Int from 0 to grid.length ){
      for( x : Int from 0 to grid[y].length ){

        // scan all directions if we find an X
        if( grid[y][x] == "X" ){
          for( d : Direction ){
            if( wordPresentInDirection("MAS", d, x, y, grid) ){
              xmasCount := xmasCount + 1;
            }
          }
        }

      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(xmasCount);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var grid := [ row.trim().split() | row in input ];

    var xmasCount := 0;
    for( y : Int from 0 to grid.length ){
      for( x : Int from 0 to grid[y].length ){

        // scan for diagonal MAS if we find an A
        // possibly start out of bounds but this will be handled by wordPresentInDirection
        if( grid[y][x] == "A" ){
          if(    (wordPresentInDirection("MAS", SouthEast, x-2, y-2, grid) || wordPresentInDirection("MAS", NorthWest, x+2, y+2, grid))
              && (wordPresentInDirection("MAS", SouthWest, x+2, y-2, grid) || wordPresentInDirection("MAS", NorthEast, x-2, y+2, grid))
          ){
            xmasCount := xmasCount + 1;
          }
        }

      }
    }


    log("----------------- AOC ANSWER PART 2 -----------------");
    log(xmasCount);
    log("-----------------------------------------------------");
  }

  function wordPresentInDirection( word : String, d : Direction, curX : Int, curY : Int, grid : [[String]] ) : Bool {
    if( word == "" ){
      return true;
    }

    // construct coordinate to check
    var x := curX;
    var y := curY;

    case(d){
      North     { y := y - 1; }
      East      { x := x + 1; }
      South     { y := y + 1; }
      West      { x := x - 1; }
      NorthEast { y := y - 1; x := x + 1; }
      SouthEast { y := y + 1; x := x + 1; }
      SouthWest { y := y + 1; x := x - 1; }
      NorthWest { y := y - 1; x := x - 1; }
    }

    // check out of bounds
    if( x < 0 || y < 0 || x >= grid[0].length || y >= grid.length ){
      return false;
    }

    // if character is present, continue search
    var chars := word.split();
    if( grid[y][x] == chars[0] ){
      return wordPresentInDirection( chars.subList(1, chars.length).concat(), d, x, y, grid );
    }

    return false;
  }

  enum Direction{
    North("N"),
    East("E"),
    South("S"),
    West("W"),
    NorthEast("NE"),
    SouthEast("SE"),
    SouthWest("SW"),
    NorthWest("NW")
  }
