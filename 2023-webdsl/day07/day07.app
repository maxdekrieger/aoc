application day07

  page root(){ "Hello world" }

  test part1 {
    var hands : [Hand];
    for( l in "../aoc-input/input-part1.txt".pathToFile().getContentAsString().trim().split("\n")) {
      hands.add(Hand.fromInputPart1(l));
    }

    var ordered := [h | h in hands order by h.score asc];
    var total := 0;
    for (i : Int from 0 to ordered.length) {
      total := total + (i+1) * ordered[i].bid;
    }

    log("----------------- AOC ANSWER PART 1 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  entity Hand {
    bid : Int
    score : Int
    cardsString : String

    static function fromInputPart1(input : String) : Hand {
      var groups := /([A-Z0-9]+)\s(\d+)/.groups(input);
      var result := Hand{
        bid := groups[2].parseInt()
        cardsString := groups[1]
      };
      var cards : [Int] := cardsToBase13Part1(groups[1]);
      var handType := getHandTypePart1(cards);
      var handTypeOrder := [highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind];
      var individualCardScore := base13HandToBase10(cards);
      result.score := (pow(13, cards.length) * handTypeOrder.indexOf(handType)) + individualCardScore;

      return result;
    }
  }

  enum HandType {
    fiveOfAKind("Five of a kind"),
    fourOfAKind("Four of a kind"),
    fullHouse("Full house"),
    threeOfAKind("Three of a kind"),
    twoPair("Two pair"),
    onePair("One pair"),
    highCard("High card")
  }

  function base13HandToBase10(cards : [Int]): Int {
    var result := 0;
    for (i : Int from 0 to cards.length) {
      var n := cards[i];
      result := result + (n * pow(13, cards.length - 1 - i));
    }
    return result;
  }

  function cardsToBase13Part1(s : String) : [Int] {
    var result := List<Int>();
    for (c in s.split()) {
      case(c) {
        "2" { result.add(0); }
        "3" { result.add(1); }
        "4" { result.add(2); }
        "5" { result.add(3); }
        "6" { result.add(4); }
        "7" { result.add(5); }
        "8" { result.add(6); }
        "9" { result.add(7); }
        "T" { result.add(8); }
        "J" { result.add(9); }
        "Q" { result.add(10); }
        "K" { result.add(11); }
        "A" { result.add(12); }
      }
    }
    return result;
  }

  function getHandTypePart1(cards : [Int]) : HandType {
    var counts : [Int];
    for (i : Int from 0 to 13) { counts.add(i-i); }
    for (c in cards) { counts.set(c, counts.get(c) + 1); }

    if ([x | x in counts where x == 5 ].length > 0) {
      return fiveOfAKind;
    }

    if ([x | x in counts where x == 4 ].length > 0) {
      return fourOfAKind;
    }

    var threeOfAKinds := [x | x in counts where x == 3 ];
    var pairs := [x | x in counts where x == 2 ];

    if (threeOfAKinds.length == 1 && pairs.length == 1) {
      return fullHouse;
    }

    if (threeOfAKinds.length == 1) {
      return threeOfAKind;
    }

    if (pairs.length == 2) {
      return twoPair;
    }

    if (pairs.length == 1) {
      return onePair;
    }

    return highCard;
  }

  function pow(a : Int, b : Int) : Int {
    if (b < 0) { return -1; }
    if (b == 0) { return 1; }
    var result := a;
    for (i : Int from 1 to b) {
      result := result * a;
    }
    return result;
  }

  test part2 {
    var hands : [Hand];
    for( l in "../aoc-input/input-part2.txt".pathToFile().getContentAsString().trim().split("\n")) {
      hands.add(Hand.fromInputPart2(l));
    }

    var ordered := [h | h in hands order by h.score asc];
    // log([h.cardsString | h in ordered]);
    var total := 0;
    for (i : Int from 0 to ordered.length) {
      total := total + (i+1) * ordered[i].bid;
    }

    log("----------------- AOC ANSWER PART 2 -----------------");
    log(total);
    log("-----------------------------------------------------");
  }

  extend entity Hand {
    static function fromInputPart2(input : String) : Hand {
      var groups := /([A-Z0-9]+)\s(\d+)/.groups(input);
      var result := Hand{
        bid := groups[2].parseInt()
        cardsString := groups[1]
      };
      var cards := cardsToBase13Part2(groups[1]);
      var handType := getHandTypePart2(cards);
      var handTypeOrder := [highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind];
      var individualCardScore := base13HandToBase10(cards);
      result.score := (pow(13, cards.length) * handTypeOrder.indexOf(handType)) + individualCardScore;

      return result;
    }
  }

  function cardsToBase13Part2(s : String) : [Int] {
    var result : [Int];
    for (c in s.split()) {
      case(c) {
        "J" { result.add(0); }
        "2" { result.add(1); }
        "3" { result.add(2); }
        "4" { result.add(3); }
        "5" { result.add(4); }
        "6" { result.add(5); }
        "7" { result.add(6); }
        "8" { result.add(7); }
        "9" { result.add(8); }
        "T" { result.add(9); }
        "Q" { result.add(10); }
        "K" { result.add(11); }
        "A" { result.add(12); }
      }
    }
    return result;
  }

  function getHandTypePart2(cards : [Int]) : HandType {
    var counts : [Int];

    for (i : Int from 0 to 13) { counts.add(0); }

    var amountOfJokers := 0;
    for (c in cards) {
      if (c == 0) {
        amountOfJokers := amountOfJokers + 1;
      } else {
        counts.set(c, counts.get(c) + 1);
      }
    }

    // log("cards: ~cards, count: ~counts, jokers: ~amountOfJokers");

    // order counts descending (starting with highest count)
    counts := [c | c in counts order by c desc];
    // add jokers to highest count
    counts.set(0, counts.get(0) + amountOfJokers);

    if ([x | x in counts where x == 5 ].length > 0) {
      return fiveOfAKind;
    }

    if ([x | x in counts where x == 4 ].length > 0) {
      return fourOfAKind;
    }

    var threeOfAKinds := [x | x in counts where x == 3 ];
    var pairs := [x | x in counts where x == 2 ];

    if (threeOfAKinds.length == 1 && pairs.length == 1) {
      return fullHouse;
    }

    if (threeOfAKinds.length == 1) {
      return threeOfAKind;
    }

    if (pairs.length == 2) {
      return twoPair;
    }

    if (pairs.length == 1) {
      return onePair;
    }

    return highCard;
  }
