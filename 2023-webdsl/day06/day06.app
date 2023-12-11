application day06

  page root(){ "Hello world" }

  test part1 {
    // parsing
    var lines := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var times := /(\d+)/.allGroups(lines[0]);
    var distances := /(\d+)/.allGroups(lines[1]);
    var races : [Race];
    for (i : Int from 0 to times.length) {
      races.add(Race{
        duration := times[i][1].parseInt()
        record := distances[i][1].parseLong()
      });
    }

    // problem solving
    var total := 1;
    for (r in races){
      var recordBeatingStrategies : [Int];
      // skip 0 and maximum time, having 0 speed or 0ms to travel wont work
      for (i : Int from 1 to r.duration) {
        if (r.beatsRecord(i)) {
          recordBeatingStrategies.add(i);
        }
      }

      total := total * recordBeatingStrategies.length;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  entity Race {
    duration : Int
    record : Long

    function beatsRecord(pressTime : Int) : Bool {
      return ((duration - pressTime) + 0L) * pressTime.toString().parseLong() > record;
    }
  }

  test part2 {
    // parsing
    var lines := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim();
    var parsedRace := [(/\s/.replaceAll("", m[0])) | m in /(\d+\s+)+(\d+)/.allGroups(lines)];
    log(parsedRace);
    var race := Race{
      duration := parsedRace[0].parseInt()
      record := parsedRace[1].parseLong()
    };

    // "problem solving" (a.k.a. brute force)
    var recordBeatingStrategies : [Int];
    // skip 0 and maximum time, having 0 speed or 0ms to travel wont work
    for (i : Int from 1 to race.duration) {
      if (race.beatsRecord(i)) {
        recordBeatingStrategies.add(i);
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(recordBeatingStrategies.length);
    log("-----------------------------------------------------");
  }
