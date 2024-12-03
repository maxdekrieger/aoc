application day03

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var result := sum( [ m[1].parseInt() * m[2].parseInt() | m in /mul\((\d{1,3}),(\d{1,3})\)/.allGroups(input) ] );

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var instructions := /do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)/.allGroups(input);
    var result := 0;

    var enabled := true;
    for( i in instructions ){
      if( i[0] == "do()"){
        enabled := true;
      } else if ( i[0] == "don't()" ){
        enabled := false;
      } else if (i[0].startsWith("mul") && enabled){
        result := result + i[1].parseInt() * i[2].parseInt();
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function sum(ns: [Int]): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
