application day05

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var pageOrderingRules : [[Int]] := [ for( i from 0 to 100 ){ List<Int>() } ];

    // construct page ordering rules
    for( m in /(\d+)\|(\d+)/.allGroups(input) ){
      pageOrderingRules[ m[1].parseInt() ].add( m[2].parseInt() );
    }

    var result := 0;

    // iterate over update lines
    for( m in [ /(\d+)/.allGroups(line[0]) | line in (/(\d+)(,\d+)+/.allGroups(input)) ] ){
      var seenPageNumbers : [Int];
      var correctlyOrdered := true;

      // keep track of all numbers seen so far
      for( pageNumber in [ pn[1].parseInt() | pn in m] ){
        if( Or [ i in pageOrderingRules[pageNumber] | i : Int in seenPageNumbers ] ){
          correctlyOrdered := false;
        }
        seenPageNumbers.add(pageNumber);
      }

      if( correctlyOrdered ){
        result := result + seenPageNumbers[ (seenPageNumbers.length / 2) ];
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n");

    // TODO

    log("----------------- AOC ANSWER PART 2 -----------------");
    log("");
    log("-----------------------------------------------------");
  }
