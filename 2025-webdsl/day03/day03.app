application day03

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");

    var sum : Long := 0L;
    for( line in input ){
      var bank := [ x.parseInt() | x in line.trim().split()];
      var joltage := highestNum(bank, 0, 2);
      log("Joltage of ~line: ~joltage");
      sum := sum + joltage;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(sum);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");

    var sum : Long := 0L;
    for( line in input ){
      var bank := [ x.parseInt() | x in line.trim().split()];
      var joltage := highestNum(bank, 0, 12);
      log("Joltage of ~line: ~joltage");
      sum := sum + joltage;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(sum);
    log("-----------------------------------------------------");
  }

  function highestNum(bank : [Int], startingAt : Int, digitsToFind : Int) : Long {
    if( digitsToFind == 0){ return 0L; } // sanity check, shouldnt happen

    var searchSpace := bank.subList(startingAt, bank.length - digitsToFind + 1);
    var highest := max(searchSpace);
    if( digitsToFind == 1 ){
      return 0L + highest; // we need to convince the compiler we are returning a Long
    } else if (digitsToFind > 1){
      var index := searchSpace.indexOf(highest);
      var nextDigits := highestNum(bank, startingAt + index + 1, digitsToFind - 1);
      return (highest.toString() + nextDigits.toString()).parseLong();
    }

    return 0L;
  }

  function max(ls : [Int]) : Int {
    if(ls.length < 1){
      return -1;
    }

    var result := ls[0];
    for( x in ls ){
      if( x > result ){
        result := x;
      }
    }
    return result;
  }
