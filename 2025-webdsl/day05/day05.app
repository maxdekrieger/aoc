application day05

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n\n");
    var ranges := [ (r.split("-")[0].parseLong(), r.split("-")[1].parseLong()) | r in input[0].split("\n")];
    var ingredients := input[1].split("\n");

    var freshIngredients := 0;
    for( i in ingredients ){
      var ingredient := i.parseLong();
      var partOfRange := false;
      for( r in ranges ){
        if( !partOfRange && ingredient >= r.first as Long && ingredient <= r.second as Long ){
          partOfRange := true;
          freshIngredients := freshIngredients + 1;
        }
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(freshIngredients);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n\n");
    var ranges := [ (r.split("-")[0].parseLong(), r.split("-")[1].parseLong()) | r in input[0].split("\n")];
    var normalizedRanges := List<(Long, Long)>();

    for( range in ranges ){
      var largerThanRanges := largerThanRanges( range, normalizedRanges );
      if( largerThanRanges.length > 0 ) { // completely larger than another range
        // remove the range(s)
        for( r in largerThanRanges ){
          log("\t\tremoving range ~r.first-~r.second");
          normalizedRanges.removeAt( normalizedRanges.indexOf(r) );
        }
      }

      var startsIn := startsIn( range, normalizedRanges );
      var endsIn := endsIn( range, normalizedRanges );

      if( startsIn != null && endsIn != null ) { // starts in one and ends in one
        // if it starts and ends in the same, we can ignore this one
        // otherwise, connect the two ranges
        if (startsIn != endsIn ){
          normalizedRanges.removeAt( normalizedRanges.indexOf(startsIn) );
          normalizedRanges.removeAt( normalizedRanges.indexOf(endsIn) );
          normalizedRanges.add( (startsIn.first as Long, endsIn.second as Long) );
        }
      }

      else if( startsIn != null ){ // starts in a range
        // extend the end of existing range
        normalizedRanges.removeAt( normalizedRanges.indexOf(startsIn) );
        normalizedRanges.add( (startsIn.first as Long, range.second as Long) );
      }

      else if( endsIn != null ){ // ends in a range
        // extend the start of existing range
        normalizedRanges.removeAt( normalizedRanges.indexOf(endsIn) );
        normalizedRanges.add( (range.first as Long, endsIn.second as Long) );
      }

      else { // new range
        normalizedRanges.add( (range.first as Long, range.second as Long) );
      }
    }

    var freshIngredientAmount := 0L;
    for( range in normalizedRanges order by range.first as Long ){
      freshIngredientAmount := freshIngredientAmount + (range.second as Long - range.first as Long) + 1;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(freshIngredientAmount);
    log("-----------------------------------------------------");
  }

  function largerThanRanges( r : (Long, Long), ranges : [(Long, Long)]) : [(Long, Long)]{
    var result := List<(Long, Long)>();
    var start := r.first as Long;
    var end := r.second as Long;

    for( range in ranges ){
      if( start <= range.first as Long && end >= range.second as Long ){
        result.add( range );
      }
    }

    return result;
  }

  function startsIn( r : (Long, Long), ranges : [(Long, Long)] ) : (Long, Long) {
    var start := r.first as Long;

    for( range in ranges ){
      if( start >= range.first as Long && start <= range.second as Long ){
        return range;
      }
    }
    return null;
  }

  function endsIn( r : (Long, Long), ranges : [(Long, Long)] ) : (Long, Long) {
    var end := r.second as Long;

    for( range in ranges ){
      if( end >= range.first as Long && end <= range.second as Long ){
        return range;
      }
    }
    return null;
  }
