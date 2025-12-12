application day08

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var boxes := List<JunctionBox>();
    for( line in input ){
      var groups := /(\d+),(\d+),(\d+)/.groups(line);
      var box := JunctionBox{ x := groups[1].parseLong(), y := groups[2].parseLong(), z := groups[3].parseLong() }.save();
      box.circuit := Circuit{}.save();
      boxes.add( box );
    }

    var distances := List<(Long, (JunctionBox, JunctionBox))>();
    for( p : Int from 0 to boxes.length ){
      for( q : Int from p + 1 to boxes.length ){
        distances.add( (distance(boxes[p], boxes[q]), (boxes[p], boxes[q])) );
      }
    }

    for( t in distances order by t.first as Long asc limit 1000 ){
      var couple := t.second as (JunctionBox, JunctionBox);
      var p := couple.first as JunctionBox;
      var q := couple.second as JunctionBox;

      if( p.circuit != q.circuit ){
        var oldCircuit := q.circuit;
        for( box in q.circuit.boxes ){
          box.circuit := p.circuit;
        }
        oldCircuit.delete();
      }
    }

    var result := 1;
    for( c : Circuit order by whyIsThisNecessary(c) desc limit 3 ){
      result := result * c.boxes.length;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function whyIsThisNecessary( c : Circuit ) : Int {
    return c.boxes.length;
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var boxes := List<JunctionBox>();
    for( line in input ){
      var groups := /(\d+),(\d+),(\d+)/.groups(line);
      var box := JunctionBox{ x := groups[1].parseLong(), y := groups[2].parseLong(), z := groups[3].parseLong() }.save();
      box.circuit := Circuit{}.save();
      boxes.add( box );
    }

    var distances := List<(Long, (JunctionBox, JunctionBox))>();
    for( p : Int from 0 to boxes.length ){
      for( q : Int from p + 1 to boxes.length ){
        distances.add( (distance(boxes[p], boxes[q]), (boxes[p], boxes[q])) );
      }
    }

    var lastP : JunctionBox;
    var lastQ : JunctionBox;
    for( t in distances order by t.first as Long asc ){
      var couple := t.second as (JunctionBox, JunctionBox);
      var p := couple.first as JunctionBox;
      var q := couple.second as JunctionBox;

      if( p.circuit != q.circuit ){
        var oldCircuit := q.circuit;
        for( box in q.circuit.boxes ){
          box.circuit := p.circuit;
        }
        oldCircuit.delete();
        if( (from Circuit).length == 1 ){
          lastP := p;
          lastQ := q;
        }
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(lastP.x * lastQ.x);
    log("-----------------------------------------------------");
  }

  entity JunctionBox{
    x : Long
    y : Long
    z : Long

    circuit : Circuit
  }

  entity Circuit {
    boxes : {JunctionBox} (inverse=circuit)
  }

  function distance( p : JunctionBox, q : JunctionBox ) : Long {
    return square(p.x - q.x) + square(p.y - q.y) + square(p.z - q.z);
  }

  native class java.lang.Math as Math {
    static sqrt(Double) : Double
  }

  function square( i : Long ) : Long {
    return i*i;
  }
