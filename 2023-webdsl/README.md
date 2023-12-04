# Advent of Code 2023 - WebDSL

Advent of Code 2023 challenges in [WebDSL](https://webdsl.org).

To run the code:

1. [Install WebDSL](https://webdsl.org/howtos/install/).
2. Change directory to the day you want to run the solution of (e.g. `cd <repo_root>/2023-webdsl/day01`).
3. Run `webdsl test day<XX>.app` where `XX` is the day you are in (e.g. `webdsl test day01.app`).

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

