application day07

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var diagram := [ line.trim().split() | line in input.split("\n") ];
    var beam := [ [ char == "S" | char in row ] | row in diagram ];
    var maxX := diagram[0].length - 1;

    var numberOfUsedSplitters := 0;
    for( y : Int from 1 to diagram.length ){
      for( x : Int from 0 to diagram[y].length ){
        if( diagram[y][x] == "." ){
          if( beam[y - 1][x] ){ // beam directly above
            beam[y].set( x, true );
          } else if ( x < maxX && diagram[y][x + 1] == "^" && beam[y - 1][x + 1] ){ // beam above splitter on the right
            beam[y].set( x, true );
          } else if (x > 0 && diagram[y][x - 1] == "^" && beam[y - 1][x - 1] ){ // beam above splitter on the left
            beam[y].set( x, true );
          }
        } else if( diagram[y][x] == "^" && beam[y-1][x] ){
          numberOfUsedSplitters := numberOfUsedSplitters + 1;
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(numberOfUsedSplitters);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var diagram := [ line.trim().split() | line in input.split("\n") ];
    var mem := [ [ (if( char == char ) -1L else -1L) | char in row ] | row in diagram ];

    var result := timelines( diagram[0].indexOf( "S" ), 0, diagram, mem );

    log("----------------- AOC ANSWER PART 2 -----------------");
    log( result );
    log("-----------------------------------------------------");
  }

  function timelines( x : Int, y : Int, diagram : [[String]], mem : [[Long]] ) : Long {
    if( mem[y][x] != -1L ){
      return mem[y][x];
    }

    var result := -1L;
    if( y == diagram.length - 1 ){ // bottom of diagram
      result := if( diagram[y][x] == "^" ) 2L else 1L;
    } else if( diagram[y][x] == "^" ){ // splitter
      result := timelines( x - 1, y, diagram, mem ) + timelines( x + 1, y, diagram, mem );
    } else { // empty space
      result := timelines( x, y + 1, diagram, mem );
    }

    mem[y].set( x, result );
    return mem[y][x];
  }
