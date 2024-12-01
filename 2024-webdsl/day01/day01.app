application day01

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var lines := /(\d+)\s+(\d+)/.allGroups(input);
    var left := [ l[1].parseInt() | l in lines ];
    var right := [ l[2].parseInt() | l in lines ];

    Collections.sort(left);
    Collections.sort(right);

    var total := 0;
    for( i : Int from 0 to left.length ){
      total := total + abs(left[i] - right[i]);
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var lines := /(\d+)\s+(\d+)/.allGroups(input);
    var left := [ l[1].parseInt() | l in lines ];
    var right := [ l[2].parseInt() | l in lines ];

    Collections.sort(right);

    var similarityScore := 0L;
    for( i : Int from 0 to left.length ){
      var startingIndex := right.indexOf(left[i]);
      if( startingIndex > -1 ){
        var multiplier := 1;
        while( startingIndex + multiplier < right.length && right[startingIndex + multiplier] == left[i] ){
          multiplier := multiplier + 1;
        }
        similarityScore := similarityScore + left[i] * multiplier;
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(similarityScore);
    log("-----------------------------------------------------");
  }

  native class java.util.Collections as Collections {
    static sort(List<Int>)
  }

  function abs(i : Int) : Int {
    return if(i < 0) (0 - i) else i;
  }