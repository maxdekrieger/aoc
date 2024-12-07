application day07

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");

    var result := 0L;

    for( equation in input ){
      var digits := [ m[1].parseLong() | m in /(\d+)/.allGroups(equation.trim()) ];
      var possibilities := [ digits[1] ];

      for( i from 2 to digits.length ){
        var updatedPossibilities := List<Long>();
        for( j from 0 to possibilities.length ){
          updatedPossibilities.add( possibilities[j] + digits[i] );
          updatedPossibilities.add( possibilities[j] * digits[i] );
        }
        possibilities := updatedPossibilities;
      }

      if( possibilities.indexOf(digits[0]) >= 0 ){
        result := result + digits[0];
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");

    var result := 0L;

    for( equation in input ){
      var digits := [ m[1].parseLong() | m in /(\d+)/.allGroups(equation.trim()) ];
      var possibilities := [ digits[1] ];

      for( i from 2 to digits.length ){
        var updatedPossibilities := List<Long>();
        for( j from 0 to possibilities.length ){
          updatedPossibilities.add( possibilities[j] + digits[i] );
          updatedPossibilities.add( possibilities[j] * digits[i] );
          updatedPossibilities.add( (possibilities[j] + "" + digits[i]).parseLong() );
        }
        possibilities := updatedPossibilities;
      }

      if( possibilities.indexOf(digits[0]) >= 0 ){
        result := result + digits[0];
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }
