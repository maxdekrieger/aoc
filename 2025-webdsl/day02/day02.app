application day02

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split(",");

    var sum : Long := 0L;
    for( range in input ){
      var numbers := range.split("-");
      var firstString := numbers[0].trim();
      var first := firstString.parseLong();
      var secondString := numbers[1].trim();
      var second := secondString.parseLong();

      var halfOfFirst := if(firstString.length() > 1) firstString.substring(0, firstString.length() / 2).parseInt() else 0;
      var halfOfSecond := secondString.substring(0, secondString.length() / 2 + mod(secondString.length(), 2)).parseInt();

      for( i : Int from halfOfFirst to halfOfSecond + 1){
        var idToCheckString := i.toString() + i.toString();
        var idToCheck := idToCheckString.parseLong();
        var invalidId := idToCheck >= first && idToCheck <= second;
        if( invalidId ){
          sum := sum + idToCheck;
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(sum);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split(",");

    var sum : Long := 0L;
    for( range in input ){
      log("Range: ~range");
      var numbers := range.split("-");
      var firstString := numbers[0].trim();
      var first := firstString.parseLong();
      var secondString := numbers[1].trim();
      var second := secondString.parseLong();

      var halfOfSecond := secondString.substring(0, secondString.length() / 2 + mod(secondString.length(), 2)).parseInt();
      var invalidIds := List<Long>();

      for( i : Int from 0 to halfOfSecond + 1 ){
        for( repeats : Int from 2 to secondString.length() + 1 ){
          var idToCheckString := "";
          for( n : Int from 0 to repeats ){
            idToCheckString := idToCheckString + i.toString();
          }

          var idToCheck := idToCheckString.parseLong();
          var invalidId := idToCheck >= first && idToCheck <= second;
          if( invalidId && !(idToCheck in invalidIds)){
            log(idToCheckString + " is invalid in the range of ~first to ~second");
            invalidIds.add(idToCheck);
            sum := sum + idToCheck;
          }
        }
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(sum);
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