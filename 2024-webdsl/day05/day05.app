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
    for( line in [ [ d[1].parseInt() | d in /(\d+)/.allGroups(line[0]) ] | line in (/(\d+)(,\d+)+/.allGroups(input)) ] ){
      if( isInCorrectOrder( line, pageOrderingRules ).first as Bool ){
        result := result + line[ (line.length / 2) ];
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var pageOrderingRules : [[Int]] := [ for( i from 0 to 100 ){ List<Int>() } ];

    // construct page ordering rules
    for( m in /(\d+)\|(\d+)/.allGroups(input) ){
      pageOrderingRules[ m[1].parseInt() ].add( m[2].parseInt() );
    }

    var result := 0;

    // iterate over update lines
    for( line in [ [ d[1].parseInt() | d in /(\d+)/.allGroups(line[0]) ] | line in (/(\d+)(,\d+)+/.allGroups(input)) ] ){
      if( ! isInCorrectOrder( line, pageOrderingRules ).first as Bool ){
        var correctLine := correctOrder( line, pageOrderingRules );
        result := result + correctLine[ (correctLine.length / 2) ];
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function isInCorrectOrder( line : [Int], pageOrderingRules : [[Int]] ) : (Bool, Int, Int) {

    // for every page number, check whether none of the earlier page numbers should be after it according to the rules
    for( i from 0 to line.length ){
      var pageNumber := line[i];
      for ( j from 0 to i ){
        if( line[j] in pageOrderingRules[pageNumber] ){
          return (false, i, j);
        }
      }
    }

    return (true, -1, -1);
  }

  function correctOrder( line : [Int], pageOrderingRules : [[Int]] ) : [Int] {
    // clone original line
    var result := [ x | x in line ];

    var feedback := isInCorrectOrder( result, pageOrderingRules );

    // mutate order while its not correct
    while( !feedback.first as Bool ){
      // insert the page number that violates a rule right before the page number that should be later
      var pageNumber := result[ feedback.second as Int ];
      result.removeAt( feedback.second as Int );
      result.insert( feedback.third as Int, pageNumber );

      feedback := isInCorrectOrder( result, pageOrderingRules );
    }

    return result;
  }
