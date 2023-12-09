application day02

  page root(){ "Hello world" }

  test part1 {
    var total := sum([
        (/Game\s(\d+)/.groups(l)[1].parseInt())
      |
        l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")
        where (!/(1[3-9]|[2-9]\d|\d{3,})\sred|(1[4-9]|[2-9]\d|\d{3,})\sgreen|(1[5-9]|[2-9]\d|\d{3,})\sblue/.find(l))
    ]);

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var total := sum([
            max([m[1].parseInt() | m in /(\d+)\sred/.allGroups(l)])
          * max([m[1].parseInt() | m in /(\d+)\sgreen/.allGroups(l)])
          * max([m[1].parseInt() | m in /(\d+)\sblue/.allGroups(l)])
        |
          l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")
    ]);

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function sum(ns: List<Int>): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }

  function max(ls : [Int]) : Int {
    return [n | n in ls order by n desc][0];
  }
