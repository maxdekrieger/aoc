application day09

  page root(){ "Hello world" }

  test part1 {
    var input := "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split();
    var digits := [ s.parseInt() | s in input ];
    var disk : [Int];

    // build up disk in memory:
    // each file block is represented by its file id
    // free space represented by -1
    var index := 0;
    for( d in digits ){
      for( i from 0 to d ){
        if( mod(index, 2) == 0 ){
          disk.add( index / 2 );
        } else{
          disk.add( -1 );
        }
      }
      index := index + 1;
    }

    var left := 0;
    var right := disk.length - 1;
    while( left < right ){
      // if we encounter a free space on the left
      // and a file block on the right
      // then move the file block to the free space
      if( disk[left] != -1 ){
        left := left + 1;
      } else if ( disk[right] == -1 ){
        right := right - 1;
      } else {
        disk.set(left, disk[right]);
        disk.set(right, -1);
      }
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log( checksum(disk) );
    log("-----------------------------------------------------");
  }

  test part2 {
    var input := "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split();
    var digits := [ s.parseInt() | s in input ];
    var disk : [Int];

    // build up disk in memory:
    // each file block is represented by its file id
    // free space represented by -1
    var index := 0;
    for( d in digits ){
      for( i from 0 to d ){
        if( mod(index, 2) == 0 ){
          disk.add( index / 2 );
        } else{
          disk.add( -1 );
        }
      }
      index := index + 1;
    }

    // iterate from end of disk to start
    var indexToMove := disk.length - 1;
    while( indexToMove >= 0 ){

      // if we encounter a file block, try to move it to the left
      // if it's not a file block, try again on one space to the left
      if( disk[indexToMove] != -1 ){

        // check whether the whole file can be moved
        var indexToPlaceFile := indexToPlaceFile( indexToMove, disk );
        var startIndexToPlaceFile := indexToPlaceFile.first as Int;
        var fileSize := indexToPlaceFile.second as Int;

        // if it can be moved, move the whole file
        // if it cannot be moved, skip the whole file
        if( startIndexToPlaceFile != -1 ){
          for( i from 0 to fileSize ){
            disk.set( startIndexToPlaceFile + i, disk[indexToMove] );
            disk.set( indexToMove, -1 );
            indexToMove := indexToMove - 1;
          }
        } else {
          indexToMove := indexToMove - fileSize;
        }
      } else {
        indexToMove := indexToMove - 1;
      }
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log( checksum(disk) );
    log("-----------------------------------------------------");
  }

  function mod(i : Int, j : Int) : Int {
    validate(j != 0, "modulo zero undefined");
    return i - (j * (i / j));
  }

  // return the leftmost index to place the file, -1 in case it's not possible
  // and the filesize as second value in the tuple
  function indexToPlaceFile( indexToMove : Int, disk : [Int] ) : (Int, Int) {

    // calculate filesize
    var i := indexToMove - 1;
    while( i >= 0 && disk[i] == disk[indexToMove] ){
      i := i - 1;
    }
    var fileSize := indexToMove - i;

    // look for first place on the left where the whole file can be moved
    var free := 0;
    i := 0;
    while( i <= indexToMove - fileSize ){
      if( disk[i] == -1 ){
        free := free + 1;
      } else{
        free := 0;
      }

      i := i + 1;

      if( free == fileSize ){
        return (i - fileSize, fileSize);
      }
    }

    return (-1, fileSize);
  }

  function checksum( disk : [Int] ) : Long {
    var result := 0L;
    for( i from 0 to disk.length ){
      if( disk[i] >= 0 ){
        result := result + disk[i]*i;
      }
    }
    return result;
  }

  function printDisk( disk : [Int] ){
    var log := "";
    for( b in disk ){
      if( b == -1 ){
        log := log + ".";
      } else{
        log := log + b;
      }
    }
    log(log);
  }