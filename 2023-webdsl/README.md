# Advent of Code 2023 - WebDSL

Advent of Code 2023 challenges in [WebDSL](https://webdsl.org).

## Template

```
application dayXX

  page root(){ "Hello world" }

  test part1 {
    for( l in "../aoc-input/example-input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      //
    }
    
    log("----------------- AOC ANSWER PART 1 -----------------");
    log("");
    log("-----------------------------------------------------");
  }

  test part2 {
    for( l in "../aoc-input/example-input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      //
    }
    
    log("----------------- AOC ANSWER PART 2 -----------------");
    log("");
    log("-----------------------------------------------------");
  }
```

