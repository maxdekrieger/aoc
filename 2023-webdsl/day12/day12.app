application day12

  page root(){ "Hello world" }

  test part1 {
    var permutationsMeetingCriteria := 0L;
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var springs := (/([\#\?\.]*)/.groups(l))[0].split();
      var correctGroups := [ g[1].parseInt() | g in /(\d+)/.allGroups(l)];

      permutationsMeetingCriteria := permutationsMeetingCriteria + correctPermutations(springs, -1, correctGroups, List<String>(), List<Long>());
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(permutationsMeetingCriteria);
    log("-----------------------------------------------------");
  }

  test part2 {
    var permutationsMeetingCriteria := 0L;
    for( l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var springs := (/([\#\?\.]*)/.groups(l))[0].split();
      var correctGroups := [ g[1].parseInt() | g in /(\d+)/.allGroups(l)];

      var expandedSprings : [String];
      var expandedCorrectGroups : [Int];
      var max := 5;
      for (i : Int from 0 to max) {
        expandedSprings.addAll(springs);
        if (i != max - 1) {
          expandedSprings.add("?");
        }
        expandedCorrectGroups.addAll(correctGroups);
      }

      permutationsMeetingCriteria := permutationsMeetingCriteria + correctPermutations(expandedSprings, -1, expandedCorrectGroups, List<String>(), List<Long>());
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(permutationsMeetingCriteria);
    log("-----------------------------------------------------");
  }


  // use two Lists as workaround for the lack of a Map type
  function correctPermutations(chars : [String], amountLeftInGroup : Int, remainingGroups : [Int], memInput : [String], memOutput : [Long]) : Long {

    // try to find this case in memorized answers
    var input := chars.concat() + amountLeftInGroup + remainingGroups.toString();
    var memIdx := memInput.indexOf(input);
    if (memIdx != -1) {
      return memOutput[memIdx];
    }

    // add this case to memorized answers
    memIdx := memInput.length;
    memInput.add(input);
    memOutput.add(-1L);

    if (chars.length == 0) {
      memOutput.set(memIdx, if (amountLeftInGroup < 1 && remainingGroups.length == 0) 1L else 0L);
      return memOutput[memIdx];
    }

    // optimizations
    if (amountLeftInGroup < 1 && remainingGroups.length == 0) {
      memOutput.set(memIdx, if (/[.?]*/.match(chars.concat())) 1L else 0L);
      return memOutput[memIdx];
    }
    if(chars.length < max(amountLeftInGroup, 0) + sum(remainingGroups) + remainingGroups.length - 1) {
      memOutput.set(memIdx, 0L);
      return memOutput[memIdx];
    }

    // match on next character
    var c := chars[0];
    case (c) {
      "." {
        if (amountLeftInGroup > 0) {
          memOutput.set(memIdx, 0L);
          return memOutput[memIdx];
        }
        memOutput.set(memIdx, correctPermutations(chars.subList(1, chars.length), -1, remainingGroups, memInput, memOutput));
        return memOutput[memIdx];
      }
      "#" {
        // continue processing a group
        if (amountLeftInGroup > 0) {
          memOutput.set(memIdx, correctPermutations(chars.subList(1, chars.length), amountLeftInGroup - 1, remainingGroups, memInput, memOutput));
          return memOutput[memIdx];
        }

        // start a new group if possible
        if (amountLeftInGroup == -1 && remainingGroups.length > 0) {
          memOutput.set(memIdx, correctPermutations(chars.subList(1, chars.length), remainingGroups[0] - 1, remainingGroups.subList(1, remainingGroups.length), memInput, memOutput));
          return memOutput[memIdx];
        }

        memOutput.set(memIdx, 0L);
        return memOutput[memIdx];
      }
      "?" {
        // case .
        var case1 := 0L;
        if (amountLeftInGroup < 1) {
          case1 := correctPermutations(chars.subList(1, chars.length), -1, remainingGroups, memInput, memOutput);
        }

        // case #
        var case2 := 0L;
        if (amountLeftInGroup > 0) {
          case2 := correctPermutations(chars.subList(1, chars.length), amountLeftInGroup - 1, remainingGroups, memInput, memOutput);
        } else if (amountLeftInGroup == -1 && remainingGroups.length > 0) {
          case2 := correctPermutations(chars.subList(1, chars.length), remainingGroups[0] - 1, remainingGroups.subList(1, remainingGroups.length), memInput, memOutput);
        }

        memOutput.set(memIdx, case1 + case2);
        return memOutput[memIdx];
      }
    }

    return null;
  }

  function max(i : Int, j : Int) : Int {
    return if(i > j) i else j;
  }

  function sum(ns: List<Int>): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
