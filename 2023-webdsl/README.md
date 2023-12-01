# Advent of Code 2023 - WebDSL

Advent of Code 2023 challenges in [WebDSL](https://webdsl.org).

## Template

```
application dayXX

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/example-input-part1.txt".pathToFile();
    for( l in input.getContentAsString().split("\\n")) {
      //
    }
  }

```

