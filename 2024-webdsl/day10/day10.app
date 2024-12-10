application day10

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var heightmap := [ [ s.parseInt() | s in row.trim().split() ] | row in input ];
    var nextmap := [ [ List<(Int, Int)>() | tile in row ] | row in heightmap ];

    // construct maps of which next
    for( y from 0 to nextmap.length ){
      for( x from 0 to nextmap[y].length ){
        var height := heightmap[y][x];
        for( d : Direction ){
          var nextCoordinateToCheck := nextCoordinate( (x,y), d );
          var xToCheck := nextCoordinateToCheck.first as Int;
          var yToCheck := nextCoordinateToCheck.second as Int;
          if( isInBounds( xToCheck, yToCheck, heightmap ) && heightmap[yToCheck][xToCheck] == height + 1 ){
            nextmap[y][x].add( (xToCheck, yToCheck) );
          }
        }
      }
    }

    var result := 0;
    for( y from 0 to nextmap.length ){
      for( x from 0 to nextmap[y].length ){
        if( heightmap[y][x] == 0 ){
          result := result + reachableNinesFrom( x, y, heightmap, nextmap ).length;
        }
      }
    }


    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var heightmap := [ [ s.parseInt() | s in row.trim().split() ] | row in input ];
    var nextmap := [ [ List<(Int, Int)>() | tile in row ] | row in heightmap ];

    // construct maps of which next
    for( y from 0 to nextmap.length ){
      for( x from 0 to nextmap[y].length ){
        var height := heightmap[y][x];
        for( d : Direction ){
          var nextCoordinateToCheck := nextCoordinate( (x,y), d );
          var xToCheck := nextCoordinateToCheck.first as Int;
          var yToCheck := nextCoordinateToCheck.second as Int;
          if( isInBounds( xToCheck, yToCheck, heightmap ) && heightmap[yToCheck][xToCheck] == height + 1 ){
            nextmap[y][x].add( (xToCheck, yToCheck) );
          }
        }
      }
    }

    var result := 0;
    for( y from 0 to nextmap.length ){
      for( x from 0 to nextmap[y].length ){
        if( heightmap[y][x] == 0 ){
          result := result + ratingFrom( x, y, heightmap, nextmap );
        }
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function isInBounds( x : Int, y : Int, grid : [[Int]] ) : Bool {
    return x >= 0 && y >= 0 && y < grid.length && x < grid[y].length;
  }

  enum Direction{
    North("N"),
    East("E"),
    South("S"),
    West("W")
  }

  function nextCoordinate( c : (Int, Int), d : Direction ) : (Int, Int) {
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

  function reachableNinesFrom( x : Int, y : Int, heightmap : [[Int]], nextmap : [[[(Int,Int)]]] ) : {(Int,Int)} {
    if( heightmap[y][x] == 9 ){
      return {(x,y)};
    }

    var result := Set<(Int,Int)>();
    for( next in nextmap[y][x] ){
      result.addAll( reachableNinesFrom( next.first as Int, next.second as Int, heightmap, nextmap ) );
    }
    return result;
  }

  function ratingFrom( x : Int, y : Int, heightmap : [[Int]], nextmap : [[[(Int,Int)]]] ) : Int {
    if( heightmap[y][x] == 9 ){
      return 1;
    }

    return sum( [ ratingFrom( next.first as Int, next.second as Int, heightmap, nextmap ) | next in nextmap[y][x] ] );
  }

  function sum(ns: [Int]): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
