application day15

  page root(){ "Hello world" }

  test part1 {
    var ascii := " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}\~".split();
    var sum := 0;

    for( step in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split(",")) {
      var hash := 0;
      for (c in step.split()) {
        var asciiCode := ascii.indexOf(c) + 32;
        hash := hash + asciiCode;
        hash := hash * 17;
        hash := hash % 256;
      }

      sum := sum + hash;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(sum);
    log("-----------------------------------------------------");
  }

  test part2 {
    var ascii := " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}\~".split();
    var boxes : [[String]];
    for (i : Int from 0 to 256) {
      boxes.add(List<String>());
    }

    for( step in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split(",")) {
      var groups := /^([a-z]+)([\-=])(\d+)?$/.groups(step);
      var label := groups[1];
      var operation := groups[2];
      var focalLength := groups[3];

      var hash := 0;
      for (c in label.split()) {
        var asciiCode := ascii.indexOf(c) + 32;
        hash := hash + asciiCode;
        hash := hash * 17;
        hash := hash % 256;
      }

      var index := -1;
      for (i : Int from 0 to boxes[hash].length) {
        if (boxes[hash][i].split(" ")[0] == label) {
          if (index != -1) {
            log("ERROR! ~label is twice in box ~hash: ~(boxes[hash])");
          }
          index := i;
        }
      }

      case (operation) {
        "=" {
          if (index == -1) {
            boxes[hash].add("~label ~focalLength");
          } else {
            boxes[hash].set(index, "~label ~focalLength");
          }
        }
        "-" {
          if (index != -1) {
            boxes[hash].removeAt(index);
          }
        }
      }
    }

    var sum := 0;
    for (i : Int from 0 to 256) {
      var box := boxes[i];
      if (box.length > 0) {
        // log("Box ~i: ~(boxes[i])");
      }
      for (j : Int from 0 to box.length) {
        var lens := box[j];
        var focusingPower := (i + 1) * (j + 1) * (lens.split(" ")[1].parseInt());
        // log("\t~lens focusing power: ~focusingPower");
        sum := sum + focusingPower;
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(sum);
    log("-----------------------------------------------------");
  }
