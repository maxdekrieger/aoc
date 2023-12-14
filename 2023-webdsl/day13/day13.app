application day13

  page root(){ "Hello world" }

  test part1 {
    var total := 0;
    for( pattern in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n\n")) { // split on double double newline
      var grid := [ l.trim().split() | l in pattern.trim().split("\n") ];
      var rowLength := grid.length;
      var colLength := grid[0].length;
      var rows : [Long];
      var columns : [Long];
      for (i : Int from 0 to colLength) {
        columns.add(0L);
      }

      // convert to decimal number based on binary rows and columns ("." => 0, "#" => 1)
      for (y : Int from 0 to rowLength) {
        rows.add(0L);
        for (x : Int from 0 to colLength) {
          if (grid[y][x] == "#") {
            rows.set(y, rows.get(y) + pow(2, colLength - 1 - x));
            columns.set(x, columns.get(x) + pow(2, rowLength - 1 - y));
          }
        }
      }

      var lastRow := -1L;
      var horizontalMirror := -1;
      for (i : Int from 0 to rowLength) {
        var row := rows[i];
        if (row == lastRow && horizontalMirror == -1) {
          if (isMirror(rows, i)) {
            horizontalMirror := i;
          }
        }
        lastRow := row;
      }

      var lastCol := -1L;
      var verticalMirror := -1;
      for (i : Int from 0 to colLength) {
        var col := columns[i];
        if (col == lastCol && verticalMirror == -1) {
          if (isMirror(columns, i)) {
            verticalMirror := i;
          }
        }
        lastCol := col;
      }

      if (horizontalMirror != -1 && verticalMirror == -1) {
        total := total + (horizontalMirror * 100);
      } else if (horizontalMirror == -1 && verticalMirror != -1) {
        total := total + verticalMirror;
      } else {
        log("ERROR! Weird mirror going on: horizontal ~horizontalMirror, vertical ~verticalMirror"); 
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

  function isMirror(collection : [Long], index : Int) : Bool {
    var before := collection.subList(0, index);
    var after := collection.subList(index, collection.length);

    for (n : Int from 0 to before.length) {
      var beforeIndex := before.length - 1 - n;
      var afterIndex := n;
      if (beforeIndex >= 0 && afterIndex < after.length) {
        if (before[beforeIndex] != after[afterIndex]) {
          return false;
        }
      }
    }

    return true;
  }

  test part2 {
    var total := 0;

    var powersOfTwo : [Long];
    for (i : Int from 0 to 30) {
      powersOfTwo.add(pow(2, i) + 0L);
    }

    for( pattern in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n\n")) { // split on double double newline
      var grid := [ l.trim().split() | l in pattern.trim().split("\n") ];
      var rowLength := grid.length;
      var colLength := grid[0].length;
      var rows : [Long];
      var columns : [Long];
      for (i : Int from 0 to colLength) {
        columns.add(0L);
      }

      // convert to decimal number based on binary rows and columns ("." => 0, "#" => 1)
      for (y : Int from 0 to rowLength) {
        rows.add(0L);
        for (x : Int from 0 to colLength) {
          if (grid[y][x] == "#") {
            rows.set(y, rows.get(y) + pow(2, colLength - 1 - x));
            columns.set(x, columns.get(x) + pow(2, rowLength - 1 - y));
          }
        }
      }

      var horizontalMirror := -1;
      for (i : Int from 1 to rowLength) {
        if (horizontalMirror == -1 && isMirrorWithoutSmudge(rows, i, powersOfTwo)) {
          horizontalMirror := i;
        }
      }

      var verticalMirror := -1;
      for (i : Int from 1 to colLength) {
        if (verticalMirror == -1 && isMirrorWithoutSmudge(columns, i, powersOfTwo)) {
          verticalMirror := i;
        }
      }

      if (horizontalMirror != -1 && verticalMirror == -1) {
        total := total + (horizontalMirror * 100);
      } else if (horizontalMirror == -1 && verticalMirror != -1) {
        total := total + verticalMirror;
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function isMirrorWithoutSmudge(collection : [Long], index : Int, powersOfTwo : [Long]) : Bool {
    var smudgeFixed := false;
    var before := collection.subList(0, index);
    var after := collection.subList(index, collection.length);

    for (n : Int from 0 to before.length) {
      var beforeIndex := before.length - 1 - n;
      var afterIndex := n;
      if (beforeIndex >= 0 && afterIndex < after.length) {
        var diff := abs(before[beforeIndex] - after[afterIndex]);
        if (diff != 0 && (smudgeFixed || !(diff in powersOfTwo) )) {
          return false;
        } else if (!smudgeFixed && diff in powersOfTwo) {
          if (ableToFixSmudge(min(before[beforeIndex], after[afterIndex]), diff, powersOfTwo)) {
            smudgeFixed := true;
          } else {
            return false;
          }
        }
      }
    }

    return smudgeFixed;
  }

  function abs(i : Long) : Long {
    return if(i < 0L) (0L - i) else i;
  }

  function min(i : Long, j : Long) : Long {
    return if(i < j) i else j;
  }

  function ableToFixSmudge(lowest : Long, diff : Long, powersOfTwo : [Long]) : Bool {
    var remainder := lowest;
    for (i : Int from 1 to powersOfTwo.length + 1) {
      var n := powersOfTwo[(powersOfTwo.length - i)];
      if (n == diff && remainder < n) {
        return true;
      } else if (n == diff) {
        return false;
      } else if (remainder >= n) {
        remainder := remainder - n;
      }
    }

    return false;
  }
