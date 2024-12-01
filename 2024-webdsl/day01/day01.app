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

    Collections.sort(left);
    Collections.sort(right);

    var similarityScore := 0L;
    var i := 0;
    var j := 0;
    while( i < left.length ){
      var multiplier := 0;

      // skip right until its current element is the same or larger as left's element
      while( j < right.length && left[i] > right[j] ){
        j := j + 1;
      }

      // count how many elements are equal
      while( j < right.length && left[i] == right[j] ){
        multiplier := multiplier + 1;
        j := j + 1;
      }

      // add result to similarity score and repeat for same numbers in left
      similarityScore := similarityScore + left[i] * multiplier;
      while( i+1 < left.length && left[i] == left[i+1] ){
        similarityScore := similarityScore + left[i] * multiplier;
        i := i + 1;
      }

      i := i + 1;
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