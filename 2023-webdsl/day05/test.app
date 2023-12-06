application test

  function f() {
    var ls := [1,2];
    ls[0];
    ls[true && false]; // gives error in editor and compiler: Wrong operand types for operator Div: ls has type [Int],[0 + 1] has type [Int], Syntax error, expected: '/'
    ls[add(0, 1)];
  }

  function add(i : Int, j : Int) : Int { return i + j; }
