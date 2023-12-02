application day02

  page root(){ "Hello world" }

  test part1 {
    var total := 0;
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var gameId := l.split(":")[0].split(" ")[1].parseInt();
      var tooMuchRed := /(1[3-9]|[2-9]\d|\d{3,})\sred/.find(l);
      var tooMuchGreen := /(1[4-9]|[2-9]\d|\d{3,})\sgreen/.find(l);
      var tooMuchBlue := /(1[5-9]|[2-9]\d|\d{3,})\sblue/.find(l);
      
      if (!tooMuchRed && !tooMuchGreen && !tooMuchBlue) {
        total := total + gameId;
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var total := 0;
    for( l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      // parsing
      var lineSplit := l.split(":");
      var sets := lineSplit[1].trim().split("; ");

      var minimumRed := 0;
      var minimumGreen := 0;
      var minimumBlue := 0;
      for (set in sets) {
        for (cubes in set.split(", ")) {
          var cubesSplit := cubes.split(" ");
          var numberOfCubes := cubesSplit[0].parseInt();
          var color := cubesSplit[1];

          if (color == "red")   { minimumRed := max(minimumRed, numberOfCubes); }
          if (color == "green") { minimumGreen := max(minimumGreen, numberOfCubes); }
          if (color == "blue")  { minimumBlue := max(minimumBlue, numberOfCubes); }
        }
      }
      total := total + (minimumRed * minimumGreen * minimumBlue);
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function max(i : Int, j : Int) : Int {
    if(i > j) { return i; } else { return j; }
  }