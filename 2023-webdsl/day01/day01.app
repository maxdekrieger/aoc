application day01

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/example-input-part1.txt".pathToFile();
    for( l in input.getContentAsString().split("\\n")) {
      //
    }
  }