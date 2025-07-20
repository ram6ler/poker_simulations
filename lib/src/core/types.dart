/// An integer interpreted as a count.
typedef Frequency = int;

/// An integer interpreted as a hand score.
typedef Strength = double;

/// A card face, from 2 to ace.
enum Face {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace;

  /// Capitalized face name.
  String get description => '${name[0].toUpperCase()}${name.substring(1)}';

  /// A single-character representation of the face.
  String get character => switch (this) {
    two => '2',
    three => '3',
    four => '4',
    five => '5',
    six => '6',
    seven => '7',
    eight => '8',
    nine => '9',
    _ => description[0],
  };
}

/// A card suit; spades, diamonds, clubs, hearts.
enum Suit {
  clubs,
  diamonds,
  hearts,
  spades;

  /// Capitalized suit name.
  String get description => '${name[0].toUpperCase()}${name.substring(1)}';

  /// A single-character representation of the suit.
  String get character => description[0];

  /// A special character symbol of the suit.
  String get symbol => switch (this) {
    clubs => '♣',
    diamonds => '♦',
    hearts => '♥',
    spades => '♠',
  };
}

/// The poker hand type of a hand.
enum HandType {
  nothing,
  pair,
  twoPair,
  threeOfAKind,
  straight,
  flush,
  fullHouse,
  fourOfAKind,
  straightFlush,
  royalFlush;

  /// The hand type, as a string.
  String get description => switch (this) {
    nothing => 'nothing',
    pair => 'pair',
    twoPair => 'two pairs',
    threeOfAKind => 'three of a kind',
    straight => 'straight',
    flush => 'flush',
    fullHouse => 'full house',
    fourOfAKind => 'four of a kind',
    straightFlush => 'straight flush',
    royalFlush => 'royal flush',
  };
}
