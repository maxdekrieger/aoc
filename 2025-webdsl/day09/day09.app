application day09

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n");
    var result := 0L;

    var tiles : [(Int, Int)];
    for( t in input ){
      var s := t.split(",");
      var x := s[0].parseInt();
      var y := s[1].parseInt();

      for( other in tiles ){
        var width := abs(other.first as Int - x) + 1;
        var height := abs(other.second as Int - y) + 1;
        var area := width.toString().parseLong() * height.toString().parseLong();
        result := if( area > result ) area else result;
      }

      tiles.add( (x, y) );
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n");
    var edges : [((Int, Int), (Int, Int))];
    var areas : [(Long, ((Int, Int), (Int, Int)))];

    // store x and y values for coordinate compression
    var xs : [Int];
    var ys : [Int];

    var tiles := List<(Int, Int)>();
    for( t in input ){
      var s := t.split(",");
      var x := s[0].parseInt();
      var y := s[1].parseInt();
      var vertex := (x, y);

      for( other in tiles ){
        var width := abs(other.first as Int - x) + 1;
        var height := abs(other.second as Int - y) + 1;
        var area := width.toString().parseLong() * height.toString().parseLong();
        areas.add( (area, ((x,y), other)) );
      }

      if( tiles.length > 0 ){
        edges.add( (tiles[tiles.length - 1], vertex) );
      }
      tiles.add( vertex );

      // store x, x+1, y and y+1 values for coordinate compression
      // the reason for x+1 and y+1 is to introduce space between U-shapes in the polygon
      xs.add(x);
      xs.add(x+1);
      ys.add(y);
      ys.add(y+1);
    }
    edges.add( (tiles[tiles.length - 1], tiles[0]) );

    // remove duplicates and sort
    xs := xs.set().list();
    ys := ys.set().list();
    Collections.sort(xs);
    Collections.sort(ys);

    // calculate for every point in the compressed grid whether it's inside or outside the polygon
    var grid : [[Bool]];
    for(y : Int from 0 to ys.length){
      grid.add(List<Bool>());
      for(x : Int from 0 to xs.length){
        grid[y].add( vertexInPolygon(xs[x], ys[y], edges) );
      }
    }

    // result is the largest area in the polygon
    // stop after finding one because it's sorted by area
    var result := -1L;
    for( area in areas order by area.first as Long desc ){
      if( result == -1L && areaInPolygon(area, grid, xs, ys) ){
        result := area.first as Long;
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(result);
    log("-----------------------------------------------------");
  }

  function abs( n : Int ) : Int {
    return if( n < 0 ) n*-1 else n;
  }

  function areaInPolygon( t : (Long, ( (Int, Int), (Int, Int))), grid: [[Bool]], xs : [Int], ys: [Int] ) : Bool {
    var first := (t.second as ((Int, Int), (Int, Int))).first as (Int, Int);
    var second := (t.second as ((Int, Int), (Int, Int))).second as (Int, Int);

    var minX := xs.indexOf(min(first.first as Int, second.first as Int));
    var maxX := xs.indexOf(max(first.first as Int, second.first as Int));
    var minY := ys.indexOf(min(first.second as Int, second.second as Int));
    var maxY := ys.indexOf(max(first.second as Int, second.second as Int));

    // if one point is outside the grid, the area is not inside the polygon
    for( x : Int from minX to maxX + 1 ){
      for( y : Int from minY to maxY + 1 ){
        if( grid[y][x] == false ){
          return false;
        }
      }
    }

    return true;
  }

  function vertexInPolygon( x : Int, y : Int, edges: [((Int, Int), (Int, Int))] ) : Bool {
    var edgesCrossed := 0;

    // cast ray to the right and see how many edges it crosses
    for( edge in edges ){
      var x1 := (edge.first as (Int, Int)).first as Int;
      var y1 := (edge.first as (Int, Int)).second as Int;
      var x2 := (edge.second as (Int, Int)).first as Int;
      var y2 := (edge.second as (Int, Int)).second as Int;

      // make sure x1 <= x2
      if( x1 > x2 ){
        var tmp := x1;
        x1 := x2;
        x2 := tmp;
      }

      // make sure y1 <= y2
      if( y1 > y2 ){
        var tmp := y1;
        y1 := y2;
        y2 := tmp;
      }

      // check if point is exactly on an edge
      if( x == x1 && x1 == x2 && y >= y1 && y <= y2 ){ // vertical edge
        return true;
      } else if (y == y1 && y1 == y2 && x >= x1 && x <= x2 ) { // horizontal edge
        return true;
      }

      // only consider vertical edges
      if( x1 == x2 && x1 > x && y >= y1 && y < y2 ){
        edgesCrossed := edgesCrossed + 1;
      }
    }

    // a vertex is inside if the ray crosses an odd amount of edges
    return mod(edgesCrossed, 2) == 1;
  }

  // mod that always returns positive
  function mod(i : Int, j : Int) : Int {
    validate(j != 0, "modulo zero undefined");

    var result := i - (j * (i / j));
    if(result < 0){
      result := result + j;
    }

    return result;
  }

  function min( i : Int, j : Int ) : Int {
    return if( i < j ) i else j;
  }

  function max( i : Int, j : Int ) : Int {
    return if( i > j ) i else j;
  }

  native class java.util.Collections as Collections {
    static sort(List<Int>)
  }
