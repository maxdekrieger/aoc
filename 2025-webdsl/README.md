# Advent of Code 2025 - WebDSL

Advent of Code 2025 challenges in [WebDSL](https://webdsl.org).

## Running the code

To execute the solution programs on the given input:

1. [Install WebDSL](https://webdsl.org/howtos/install/).
2. Change directory to the day you want to run the solution of (e.g. `cd <repo_root>/2025-webdsl/day01`).
3. Run `webdsl test day<XX>.app` where `XX` is the day you are in (e.g. `webdsl test day01.app`).

## Input

The input files are not committed in this repository as this is against the rules. Snippet from [adventofcode.com/2025/about](https://adventofcode.com/2025/about):

> Can I copy/redistribute part of Advent of Code? Please don't. Advent of Code is free to use, not free to copy. If you're posting a code repository somewhere, please don't include parts of Advent of Code like the puzzle text or your inputs. If you're making a website, please don't make it look like Advent of Code or name it something similar.

The template below assumes every day has an `aoc-input/` folder (e.g. `./2025-webdsl/day01/aoc-input/`), with four text files:

- `example-input-part1.txt`
- `example-input-part2.txt`
- `input-part1.txt`
- `input-part2.txt`

Note that the input for both parts are almost always the same, but this allows testing with different input for both parts.

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

