application day09

  page root(){ "Hello world" }

  test part1 {
    var total := 0L;
    for( l in [l.trim() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")]) {
      var layers : [[Long]];
      layers.add([d.parseLong() | d in l.split(" ")]);

      var completelyZero := false;
      var previousLayer := layers[0];

      while (!completelyZero) {
        var derivative : [Long];
        completelyZero := true;

        for (i : Int from 1 to previousLayer.length) {
          var diff := previousLayer[i] - previousLayer[(i-1)];
          completelyZero := completelyZero && diff == 0L;
          derivative.add(diff);
        }
        layers.add(derivative);
        previousLayer := derivative;
      }

      var toAdd := 0L;
      for (i : Int from 2 to layers.length) {
        var layer := layers[(layers.length - i)];
        toAdd := toAdd + layer[(layer.length - 1)];
      }
      var new := layers[0][(layers[0].length - 1)] + toAdd;
      total := total + new;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var total := 0L;
    for( l in [l.trim() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")]) {
      var layers : [[Long]];
      layers.add(reverse([d.parseLong() | d in l.split(" ")]));

      var completelyZero := false;
      var previousLayer := layers[0];

      while (!completelyZero) {
        var derivative : [Long];
        completelyZero := true;

        for (i : Int from 1 to previousLayer.length) {
          var diff := previousLayer[i] - (previousLayer[(i-1)]);
          completelyZero := completelyZero && diff == 0L;
          derivative.add(diff);
        }
        layers.add(derivative);
        previousLayer := derivative;
      }

      var toAdd := 0L;
      for (i : Int from 2 to layers.length) {
        var layer := layers[(layers.length - i)];
        toAdd := toAdd + layer[(layer.length - 1)];
      }

      var new := layers[0][(layers[0].length - 1)] + toAdd;
      total := total + new;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function reverse(ls : [Long]): [Long] {
    var result : [Long];
    var length := ls.length;
    for (i : Int from 1 to (length + 1)) {
      result.add(ls[(length - i)]);
    }
    return result;
  }
