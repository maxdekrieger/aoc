application day01

  page root(){ "Hello world" }

  test part1 {
    var total := 0;
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var first_digit := "";
      var last_digit := "";

      for (c in l.split()) {
        if (is_digit(c)) {
          if (first_digit == "") { first_digit := c; }
          last_digit := c;
        }
      }
      total := total + (first_digit + last_digit).parseInt();
    }
    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  test part2 {
    var total := 0;
    for( l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      var first_digit := "";
      var last_digit := "";
      var last_five_chars := ["", "", "", "", ""];

      for (c in l.split()) {
        last_five_chars := [last_five_chars[1], last_five_chars[2], last_five_chars[3], last_five_chars[4], c];
        if (is_digit(c)) {
          if (first_digit == "") { first_digit := c; }
          last_digit := c;
        } else {
          var textual_digit := get_textual_digit(last_five_chars);
          if (textual_digit != null) {
            if (first_digit == "") { first_digit := textual_digit; }
            last_digit := textual_digit;
          }
        }
      }
      total := total + (first_digit + last_digit).parseInt();
    }
    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  function is_digit(s : String): Bool {
    return /[1-9]/.match(s);
  }

  function get_textual_digit(chars : [String]): String {
    var textual_digits := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    var last_five_chars := chars[0] + chars[1] + chars[2] + chars[3] + chars[4];
    var last_four_chars := chars[1] + chars[2] + chars[3] + chars[4];
    var last_three_chars := chars[2] + chars[3] + chars[4];

    if (last_five_chars in textual_digits) {
      return (textual_digits.indexOf(last_five_chars) + 1).toString();
    } else if (last_four_chars in textual_digits) {
      return (textual_digits.indexOf(last_four_chars) + 1).toString();
    } else if (last_three_chars in textual_digits) {
      return (textual_digits.indexOf(last_three_chars) + 1).toString();
    }

    return null;
  }
