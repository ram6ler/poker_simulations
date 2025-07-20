import 'types.dart' show Face, Suit;

/// A poker playing card.
class Card {
  /// Card position in pack before shuffling.
  final int index;

  /// Face of the card.
  final Face face;

  /// Suit of the card.
  final Suit suit;

  /// Creates a card from its position (index) in a deck arranged
  /// in order of face value (aces high) and, alphabetically, suits:
  ///
  /// ```text
  ///  0: 2♣   1: 3♣   2: 4♣   3: 5♣
  ///  4: 6♣   5: 7♣   6: 8♣   7: 9♣
  ///  8: T♣   9: J♣  10: Q♣  11: K♣
  /// 12: A♣  13: 2♦  14: 3♦  15: 4♦
  /// 16: 5♦  17: 6♦  18: 7♦  19: 8♦
  /// 20: 9♦  21: T♦  22: J♦  23: Q♦
  /// 24: K♦  25: A♦  26: 2♥  27: 3♥
  /// 28: 4♥  29: 5♥  30: 6♥  31: 7♥
  /// 32: 8♥  33: 9♥  34: T♥  35: J♥
  /// 36: Q♥  37: K♥  38: A♥  39: 2♠
  /// 40: 3♠  41: 4♠  42: 5♠  43: 6♠
  /// 44: 7♠  45: 8♠  46: 9♠  47: T♠
  /// 48: J♠  49: Q♠  50: K♠  51: A♠
  /// ```
  Card.fromIndex(this.index)
    : face = Face.values[index % 13],
      suit = Suit.values[index ~/ 13];

  /// Creates a card with given face and suit.
  factory Card(Face face, Suit suit) =>
      Card.fromIndex(suit.index * 13 + face.index);

  String get drawing =>
      '.--.\n'
      '|$this|\n'
      "'--'";

  @override
  String toString() => '${face.character}${suit.symbol}';

  @override
  int get hashCode => index.hashCode;

  @override
  bool operator ==(Object that) => that is Card && that.index == index;
}
