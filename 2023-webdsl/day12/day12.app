application day12

  page root(){ "Hello world" }

  test part1 {
    var permutationsMeetingCriteria := 0;
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var springs := /([\#\?\.]*)/.groups(l)[0].split();
      var correctGroups := [ g[1].parseInt() | g in /(\d+)/.allGroups(l)];

      var permutations := [p.concat() | p in createPermutations(springs)];

      for (p in permutations) {
        var groups := [ g[2].length() | g in /(^|\.)(\#+)(?=\.|$)/.allGroups(p) ];
        var allowed := groups == correctGroups;
        if (allowed) {
          permutationsMeetingCriteria := permutationsMeetingCriteria + 1;
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(permutationsMeetingCriteria);
    log("-----------------------------------------------------");
  }

  function createPermutations(chars : [String]) : [[String]] {
    var index := chars.indexOf("?");
    if (index >= 0) {
      var f : [String]; f.addAll(chars); f.set(index, ".");
      var t : [String]; t.addAll(chars); t.set(index, "#");
      var result : [[String]];
      result.addAll(createPermutations(f));
      result.addAll(createPermutations(t));
      return result;
    } else {
      return [chars];
    }
  }

  test part2 {
    for( l in "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log("");
    log("-----------------------------------------------------");
  }
