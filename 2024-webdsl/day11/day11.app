application day11

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var initialArrangement := [ m[1].parseLong() | m in /(\d+)/.allGroups(input) ];
    var amountOfStonesAfterBlinks := [ [ for( j from 0 to 26 ){ 0L } ] | i in [ for( i from 0 to 10000 ){ i } ] ];

    var result := 0L;
    for( stone in initialArrangement ){
      result := result + amountOfStonesAfterBlinks( stone, 25, amountOfStonesAfterBlinks );
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var initialArrangement := [ m[1].parseLong() | m in /(\d+)/.allGroups(input) ];
    var amountOfStonesAfterBlinks := [ [ for( j from 0 to 76 ){ 0L } ] | i in [ for( i from 0 to 10000 ){ i } ] ];

    var result := 0L;
    for( stone in initialArrangement ){
      result := result + amountOfStonesAfterBlinks( stone, 75, amountOfStonesAfterBlinks );
    }
    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function amountOfStonesAfterBlinks( stone : Long, blinksLeft : Int, cache : [[Long]] ) : Long {
    if( blinksLeft == 0 ){
      return 1L;
    }

    var result := 0L;
    if( stone < cache.length && cache[stone.intValue()][blinksLeft] != 0 ){
      result := cache[stone.intValue()][blinksLeft];
    } else if( stone == 0 ){
      result := amountOfStonesAfterBlinks( 1L, blinksLeft - 1, cache );
    } else if( hasEvenAmountOfDigits( stone ) ){
      var firstStone := stone.toString().split().subList(0, stone.toString().length() / 2).concat().parseLong();
      var secondStone := stone.toString().split().subList(stone.toString().length() / 2, stone.toString().length()).concat().parseLong();
      result := amountOfStonesAfterBlinks( firstStone, blinksLeft - 1, cache );
      result := result + amountOfStonesAfterBlinks( secondStone, blinksLeft - 1, cache );
    } else {
      result := amountOfStonesAfterBlinks( stone * 2024, blinksLeft - 1, cache );
    }

    if( stone < cache.length ){
      cache[stone.intValue()].set( blinksLeft, result );
    }

    return result;
  }

  function hasEvenAmountOfDigits( i : Long ) : Bool {
    var l := i.toString().length();
    return l - (2 * (l / 2)) == 0;
  }
