application day06

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var lines := [ [ matches[0].parseLong() | matches in /(\d+)/.allGroups(line)] | line in input ];
    lines.removeAt( lines.length - 1); // remove the operands
    var operands := [ match[0] | match in /([\*\+])/.allGroups(input[input.length - 1]) ];

    var result := 0L;
    for( column : Int from 0 to lines[0].length ){
      var columnResult := if( operands[column] == "+" ) 0L else 1L;
      for( line in lines ){
        if( operands[column] == "+" ) {
          columnResult := columnResult + line[column];
        } else {
          columnResult := columnResult * line[column];
        }
      }
      result := result + columnResult;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var inputChars := [ line.split() | line in input ];
    var operands := [ match[0] | match in /([\*\+])/.allGroups(input[input.length - 1]) ];

    // find the start index of every column in the worksheet
    var colStarts := List<Int>();
    var operandsLineChars := inputChars[inputChars.length - 1];
    for( idx : Int from 0 to operandsLineChars.length ){
      if( operandsLineChars[idx] == "+" || operandsLineChars[idx] == "*" ){
        colStarts.add(idx);
      }
    }

    var result := 0L;

    // for every column in the worksheet
    for( column : Int from 0 to colStarts.length ){
      var columnResult := if( operands[column] == "+" ) 0L else 1L;

      // iterate over the amount of digits in the column
      var colStartIdx := colStarts[column];
      var colEndIdx := if( column == colStarts.length - 1 ) input[0].length() else (colStarts[column + 1] - 1);
      for( colIdx : Int from colStartIdx to colEndIdx ){

        // build the number
        var numberString := "";
        for( rowIdx : Int from 0 to input.length - 1 ){
          numberString := numberString + inputChars[rowIdx][colIdx];
        }

        // add or multiply the worksheet column result
        if( operands[column] == "+" ){
          columnResult := columnResult + numberString.trim().parseLong();
        } else {
          columnResult := columnResult * numberString.trim().parseLong();
        }
      }

      result := result + columnResult;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }