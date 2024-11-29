application day04

  page root(){ "Hello world" }

  test part1 {
    var total := 0;
    for( l in [l.trim() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")]) {
      var winningNumbers := [m[1].parseInt() | m in /(\d+)\s/.allGroups(l.split("|")[0])];
      var numbers := [m[1].parseInt() | m in /\s(\d+)/.allGroups(l.split("|")[1])];

      var amountOfWinningNumbers := 0;
      for (n in numbers) {
        if (n in winningNumbers) {
          amountOfWinningNumbers := amountOfWinningNumbers + 1;
        }
      }

      if (amountOfWinningNumbers > 0) {
        total := total + pow(2, amountOfWinningNumbers - 1);
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function pow(a : Int, b : Int) : Int {
    if (b < 0) { return -1; }
    if (b == 0) { return 1; }
    var result := a;
    for (i : Int from 1 to b) {
      result := result * a;
    }
    return result;
  }

  test part2 {
    var cards := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var copies := [1 | c in cards];
    copies.insert(0, 0);

    for( i : Int from 1 to cards.length + 1) {
      // parsing
      var winningNumbers := [m[1].parseInt() | m in /(\d+)\s/.allGroups(l.split("|")[0])];
      var numbers := [m[1].parseInt() | m in /\s(\d+)/.allGroups(l.split("|")[1])];

      var amountOfWinningNumbers := 0;
      for (n in numbers) {
        if (n in winningNumbers) {
          amountOfWinningNumbers := amountOfWinningNumbers + 1;
        }
      }

      for (j : Int from 1 to amountOfWinningNumbers + 1) {
        copies.set(i + j, copies.get(i + j) + (copies.get(i)));
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(sum(copies));
    log("-----------------------------------------------------");
  }

  function sum(ns: [Int]): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
