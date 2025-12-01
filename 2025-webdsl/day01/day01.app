application day01

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");

    var pos := 50;
    var amountPointingAtZero := 0;
    for( line in input ){
      var clicks := line.substring(1).parseInt();
      pos := mod(pos + (if (line.substring(0,1) == "L") -1 * clicks else clicks), 100);

      if(pos == 0){
        amountPointingAtZero := amountPointingAtZero + 1;
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(amountPointingAtZero);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");

    var pos := 50;
    var amountPassingZero := 0;
    for( line in input ){
      var clicks := line.substring(1).parseInt();
      var newPos := pos + (if (line.substring(0,1) == "L") -1 * clicks else clicks);

      if(newPos <= 0){
        if(pos > 0) { // if the previous position was not zero, but it is now
          amountPassingZero := amountPassingZero + 1;
        }

        amountPassingZero := amountPassingZero + abs(newPos / 100);
      } else { // newPos > 0
        amountPassingZero := amountPassingZero + newPos / 100;
      }

      pos := mod(newPos, 100);
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(amountPassingZero);
    log("-----------------------------------------------------");
  }

  function mod(i : Int, j : Int) : Int {
    validate(j != 0, "modulo zero undefined");

    var result := i - (j * (i / j));
    if(result < 0){
      result := result + j;
    }

    return result;
  }

  function abs(i : Int) : Int {
    return if(i < 0) (0 - i) else i;
  }
