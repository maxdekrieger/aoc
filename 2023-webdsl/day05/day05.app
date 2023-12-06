application day05

  page root(){ "Hello world" }

  test part1 {
    // parsing
    var seeds := List<Long>();
    var maps := List<AlmanacMap>();
    for (l in [l.trim() | l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")]) {
      if (l.startsWith("seeds: ")) {
        seeds := [match[1].parseLong() | match in /(\d+)/.allGroups(l)];
      } else if (l.endsWith("map:")) {
        maps.add(AlmanacMap{});
      } else if (l == "") {
        // ignore
      } else {
        var currentMap := maps.get(maps.length - 1);
        var matches : [Long] := [n.parseLong() | n in /(\d+)\s(\d+)\s(\d+)/.groups(l)];
        currentMap.ranges.add(MapRange{
          destinationStart := matches[1]
          sourceStart := matches[2]
          length := matches[3]
        });
      }
    }

    // problem solving
    var minimumLocation : Long := 9223372036854775807L;
    for (seed in seeds) {
      var currentNumber := seed;
      for (map in maps) {
        currentNumber := map.mapNumber(currentNumber);
      }
      minimumLocation := min(minimumLocation, currentNumber);
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(minimumLocation);
    log("-----------------------------------------------------");
  }

  entity AlmanacMap {
    ranges : [MapRange]

    // map a source number to destination number
    // using the defined MapRanges
    function mapNumber(n : Long) : Long {
      for (range in ranges) {
        if (n >= range.sourceStart && n < (range.sourceStart + range.length)) {
          return n + range.modifier;
        }
      }

      // not found in any ranges, then its equal to its original value
      return n;
    }
  }

  entity MapRange {
    destinationStart : Long
    sourceStart : Long
    length : Long
    modifier : Long := (destinationStart - sourceStart)
    destinationEnd : Long := destinationStart + length
    sourceEnd : Long := sourceStart + length
  }

  function min(i : Long, j : Long) : Long {
    if(i > j) { return j; } else { return i; }
  }

  test part2 {
    var seedRanges := List<Range>();
    var maps := List<AlmanacMap>();
    for (l in [l.trim() | l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")]) {
      // convert seeds to ranges with themselves as origin
      if (l.startsWith("seeds: ")) {
        var seedRangesParsed := [match[1].parseLong() | match in /(\d+)/.allGroups(l)];
        var j := 0;
        while (j < seedRangesParsed.length) {
          seedRanges.add(Range{
            start := seedRangesParsed[j]
            length := seedRangesParsed[(j+1)]
          });
          j := j + 2;
        }
      }
      // build maps
      else if (l.endsWith("map:")) {
        maps.add(AlmanacMap{});
      } else if (l == "") {
        // ignore empty lines
      } else {
        var currentMap := maps.get(maps.length - 1);
        var matches : [Long] := [n.parseLong() | n in /(\d+)\s(\d+)\s(\d+)/.groups(l)];
        currentMap.ranges.add(MapRange{
          destinationStart := matches[1]
          sourceStart := matches[2]
          length := matches[3]
        });
      }
    }

    var ranges := seedRanges;
    for (i : Int from 0 to maps.length) {
      var m := maps[i];
      m.fillAndOrderRanges();
      m.log(i+1);
      var newRanges := List<Range>();
      for (r in ranges) {
        newRanges.addAll(m.mapRange(r));
      }
      ranges := newRanges;

      log("ranges after map ~(i+1)");
      for (r in ranges) {
        r.log();
      }
      log("");
    }

    var minimumLocation : Long := 9223372036854775807L;
    for (r in ranges) {
      minimumLocation := min(minimumLocation, r.start);
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(minimumLocation);
    log("-----------------------------------------------------");
  }

  entity Range {
    start : Long
    length : Long
    end : Long := start + length

    function log() {
      log("  [~start .. ~end)");
    }
  }

  extend entity AlmanacMap {
    function fillAndOrderRanges() {
      ranges := [r | r in ranges order by r.sourceStart asc];
      if (ranges[0].sourceStart > 0) {
        ranges.insert(0, MapRange{
          sourceStart := 0L,
          destinationStart := 0L,
          length := ranges[0].sourceStart
        });
      }

      var newRanges := List<MapRange>();
      newRanges.addAll(ranges);
      for (i : Int from 1 to ranges.length) {
        var prev := ranges[(i-1)];
        var next := ranges[i];
        var diff := next.sourceStart - prev.sourceEnd;
        if (diff > 0) {
          newRanges.insert(i, MapRange{
            sourceStart := prev.sourceEnd
            destinationStart := prev.sourceEnd
            length := diff
          });
        }
      }
      ranges := newRanges;
    }

    function mapRange(r : Range) : [Range] {
      // split ranges into multiple ranges based on the map
      var result := List<Range>();
      var start := r.start;
      var done := false;
      for (mr in ranges) {
        if (!done && start >= mr.sourceStart && start < mr.sourceEnd) {
          var newResultRange := Range{
            start := start
            length := min(r.end, mr.sourceEnd) - start
          };
          result.add(newResultRange);
          start := newResultRange.end;
          done := start >= r.end;
        }
      }
      // if a part of the input range it larger than the largest MapRange,
      // do not discard it but just add it
      if (!done) {
        result.add(Range{
          start := start
          length := r.end - start
        });
      }

      // transform split ranges
      for (newR in result) {
        newR.start := mapNumber(newR.start);
      }

      return result;
    }

    function rangeUsedForSourceNumber(n : Long) : Int {
      for (i : Int from 0 to ranges.length) {
        if (n < ranges[i].sourceEnd) {
          return i;
        }
      }

      // if a number is after the last range, return length (= last index + 1)
      return ranges.length;
    }

    function log(index : Int) {
      log("--- MAP ~index ---");
      for (r in ranges) {
        log("  ~r.sourceStart .. ~r.sourceEnd => ~r.destinationStart .. ~r.destinationEnd");
      }
      log("");
    }
  }
