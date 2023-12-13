application day12

  page root(){ "Hello world" }

//   test part1 {
//     var permutationsMeetingCriteria := 0;
//     for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
//       var springs := /([\#\?\.]*)/.groups(l)[0].split();
//       var correctGroups := [ g[1].parseInt() | g in /(\d+)/.allGroups(l)];
// 
//       var permutations := [p.concat() | p in createPermutations(springs)];
// 
//       for (p in permutations) {
//         var groups := [ g[2].length() | g in /(^|\.)(\#+)(?=\.|$)/.allGroups(p) ];
//         var allowed := groups == correctGroups;
//         if (allowed) {
//           permutationsMeetingCriteria := permutationsMeetingCriteria + 1;
//         }
//       }
//     }
// 
//     log("----------------- AOC ANSWER PART 1 -----------------");
//     log(permutationsMeetingCriteria);
//     log("-----------------------------------------------------");
//   }
// 
//   function createPermutations(chars : [String]) : [[String]] {
//     var index := chars.indexOf("?");
//     if (index >= 0) {
//       var f : [String]; f.addAll(chars); f.set(index, ".");
//       var t : [String]; t.addAll(chars); t.set(index, "#");
//       var result : [[String]];
//       result.addAll(createPermutations(f));
//       result.addAll(createPermutations(t));
//       return result;
//     } else {
//       return [chars];
//     }
//   }

  test part2 {
    var permutationsMeetingCriteria := 0L;
    counter.reset();
    for( l in "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
    // var l := "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n")[0];
      var springs := /([\#\?\.]*)/.groups(l)[0].split();
      var correctGroups := [ g[1].parseInt() | g in /(\d+)/.allGroups(l)];

      var expandedSprings : [String];
      var expandedCorrectGroups : [Int];
      for (i : Int from 0 to 2) {
        expandedSprings.addAll(springs);
        expandedCorrectGroups.addAll(correctGroups);
      }

      // counter.reset();
      permutationsMeetingCriteria := permutationsMeetingCriteria + correctPermutations(expandedSprings, -1, expandedCorrectGroups);
      counter.inc(); counter.log();
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(permutationsMeetingCriteria);
    log("-----------------------------------------------------");
  }

  function correctPermutations(chars : [String], amountLeftInGroup : Int, remainingGroups : [Int]) : Int {
    // counter.inc();

    if (chars.length == 0) {
      return if (amountLeftInGroup < 1 && remainingGroups.length == 0) 1 else 0;
    }

    // optimizations:
    if (amountLeftInGroup < 1 && remainingGroups.length == 0) {
      return if (/[.?]*/.match(chars.concat())) 1 else 0;
    }
    if(chars.length < max(amountLeftInGroup, 0) + sum(remainingGroups) + remainingGroups.length - 1) {
      // log("~chars.length < ~(max(amountLeftInGroup, 0) + sum(remainingGroups) + remainingGroups.length - 1)");
      return 0;
    }

    var c := chars[0];
    case (c) {
      "." {
        if (amountLeftInGroup > 0) { return 0; }
        return correctPermutations(chars.subList(1, chars.length), -1, remainingGroups);
      }
      "#" {
        // continue processing a group
        if (amountLeftInGroup > 0) {
          return correctPermutations(chars.subList(1, chars.length), amountLeftInGroup - 1, remainingGroups);
        }

        // start a new group if possible
        if (amountLeftInGroup == -1 && remainingGroups.length > 0) {
          return correctPermutations(chars.subList(1, chars.length), remainingGroups[0] - 1, remainingGroups.subList(1, remainingGroups.length));
        }

        return 0;
      }
      "?" {
        // case .
        var case1 := 0;
        if (amountLeftInGroup < 1) {
          case1 := correctPermutations(chars.subList(1, chars.length), -1, remainingGroups);
        }

        // case #
        var case2 := 0;
        if (amountLeftInGroup > 0) {
          case2 := correctPermutations(chars.subList(1, chars.length), amountLeftInGroup - 1, remainingGroups);
        } else if (amountLeftInGroup == -1 && remainingGroups.length > 0) {
          case2 := correctPermutations(chars.subList(1, chars.length), remainingGroups[0] - 1, remainingGroups.subList(1, remainingGroups.length));
        }

        return case1 + case2;
      }
    }

    return null;
  }

  var counter := Counter{ i := 0 }

  entity Counter {
    i : Int

    function inc() {
      i := i + 1;
    }

    function reset() {
      i := 0;
    }

    function log() {
      log("Count: ~i");
    }
  }

  function max(i : Int, j : Int) : Int {
    return if(i > j) i else j;
  }

  function sum(ns: List<Int>): Int {
    var s := 0;
    for(n: Int in ns) { s := s + n; }
    return s;
  }
