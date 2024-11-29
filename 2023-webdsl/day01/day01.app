application day01

  page root(){ "Hello world" }

  test part1 {
    var total := 0;
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var digits := [d[1] | d in /(\d)/.allGroups(l)];
      total := total + (digits[0] + digits[(digits.length - 1)]).parseInt();
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var total := 0;
    for( l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var digits := [toDigitString(d[1]) | d in /(?=(\d|one|two|three|four|five|six|seven|eight|nine))./.allGroups(l)];
      var toAdd := (digits[0] + digits[(digits.length - 1)]).parseInt();
      total := total + toAdd;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function toDigitString(s : String) : String {
    var digits := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    if (s in digits) {
      return (digits.indexOf(s) + 1).toString();
    }
    return s;
  }
