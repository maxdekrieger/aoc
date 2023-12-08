application day08

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim();
    var instructions : [String] := /([RL]+)/.groups(input)[1].split();
    var parsedNodes : [[String]] := /([A-Z]+)\s=\s\(([A-Z]+)\,\s([A-Z]+)\)/.allGroups(input);
    var nodes : [Node];
    for (pn in parsedNodes) {
      var n := getUniqueNode(pn[1]);
      n.left := getUniqueNode(pn[2]);
      n.right := getUniqueNode(pn[3]);
      nodes.add(n);
    }

    var zzzReached := false;
    var steps := 0;
    var curNode := getUniqueNode("AAA");
    while (!zzzReached) {
      for (i in instructions) {
        if (!zzzReached) {
          case (i) {
            "L" { curNode := curNode.left; }
            "R" { curNode := curNode.right; }
            default { log("error! instruction: ~i"); }
          }
          steps := steps + 1;
          zzzReached := curNode.text == "ZZZ";
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(steps);
    log("-----------------------------------------------------");
  }

  entity Node {
    text : String (id)

    left : Node
    right : Node
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var instructions : [String] := /([RL]+)/.groups(input)[1].split();
    var parsedNodes : [[String]] := /([0-9A-Z]+)\s=\s\(([0-9A-Z]+)\,\s([0-9A-Z]+)\)/.allGroups(input);
    var nodes : [Node];
    for (pn in parsedNodes) {
      var n := getUniqueNode(pn[1]);
      n.left := getUniqueNode(pn[2]);
      n.right := getUniqueNode(pn[3]);
      nodes.add(n);
    }

    var startingNodes := [n | n in nodes where n.text.endsWith("A")];
    var stepsToEnd : [Long];
    for (n in startingNodes) {
      var done := false;
      var steps := 0L;
      var curNode := n;
      while (!done) {
        for (instr in instructions) {
          if (!done) {
            case (instr) {
              "L" {
                curNode := curNode.left;
              }
              "R" {
                curNode := curNode.right;
              }
              default { log("error! instruction: ~instr"); }
            }
            steps := steps + 1L;
            if (curNode.text.endsWith("Z")) {
              done := true;
              stepsToEnd.add(steps);
            }
          }
        }
      }
    }

    var result := lcm(stepsToEnd);

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  /*
   * Least common multiple of a collection of numbers
   * "inspired by" *cough* www.geeksforgeeks.org/lcm-of-given-array-elements/
   * time Complexity: O(n * log(min(a, b))) where n is the size of the collection and 
   */
  function lcm(elements : [Long]): Long {
    var lcm := 1L;
    var divisor := 2L;

    while (true) {
      var counter := 0L;
      var divisible := false;

      for (i : Int from 0 to elements.length) {

        if (elements[i] == 0L) {
          return 0L;
        } else if (elements[i] < 0L) {
          elements.set(i, elements[i] * (-1L));
        }

        if (elements[i] == 1L) {
          counter := counter + 1L;
        }

        if (elements[i] % divisor == 0L) {
          divisible := true;
          elements.set(i, elements[i] / divisor);
        }
      }

      if (divisible) {
        lcm := lcm * divisor;
      } else {
        divisor := divisor + 1L;
      }

      if (counter == elements.length) {
        return lcm;
      }
    }
  }
