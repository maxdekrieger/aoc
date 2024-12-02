application day02

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var safeReports := [ x | x in input where isSafeReport( [ m[1].parseInt() | m in /(\d+)/.allGroups(x) ], false ) ];

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(safeReports.length);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var safeReports := [ r | r in input where isSafeReport( [ match[1].parseInt() | match in /(\d+)/.allGroups(r) ], true ) ];

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(safeReports.length);
    log("-----------------------------------------------------");
  }

  function isSafeReport(levels : [Int], problemDampenerAvailable : Bool) : Bool {
    var increasing := levels[1] > levels[0];

    for( i : Int from 0 to levels.length - 1 ){
      var diff := if(increasing) (levels[i+1] - levels[i]) else (levels[i] - levels[i+1]);
      if( diff < 1 || diff > 3){
        return problemDampenerAvailable
            && (    isSafeReport(listWithoutIndex(levels, i), false)
                 || isSafeReport(listWithoutIndex(levels, i+1), false)
                 || (i == 1 && isSafeReport(listWithoutIndex(levels, 0), false))
               );
      }
    }

    return true;
  }

  function listWithoutIndex(l : [Int], i : Int) : [Int] {
    var clone := [e | e in l];
    clone.removeAt(i);
    return clone;
  }
