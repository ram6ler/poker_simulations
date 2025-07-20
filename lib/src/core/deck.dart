import 'dart:math' show Random;
import 'card.dart' show Card;
import '../extensions/list_of_cards.dart' show StringsFromListOfCards;
import '../exceptions/exceptions.dart' show CardDepletionException;

class Deck {
  final List<Card> _cards;

  /// A copy of the cards in the deck.
  List<Card> get cards => [for (final card in _cards) card];
  int _position = 0;

  /// A deck consisting of the 52 standard poker cards
  /// in order of faces (aces high) and, alphabetically,
  /// suits:
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
  ///
  Deck() : _cards = [for (var i = 0; i < 52; i++) Card.fromIndex(i)];

  /// A deck consisting of the 52 standard poker cards with
  /// the cards in `cards` removed.
  Deck.withCardsRemoved(List<Card> cards)
    : _cards = [for (var i = 0; i < 52; i++) Card.fromIndex(i)]
        ..removeWhere((card) => cards.contains(card));

  /// Returns all cards originally in the deck and shuffles.
  void shuffle({int? seed}) {
    final rand = Random(seed);
    _position = 0;
    _cards.sort((a, b) => [-1, 0, 1][rand.nextInt(3)]);
  }

  /// Returns `n` cards taken from the pack, if possible.
  /// Throws a `CardDepletionError` if there are no more cards in the deck.
  List<Card> take(int n) {
    final cardsTaken = <Card>[];
    for (var i = 0; i < n; i++) {
      if (_position < _cards.length) {
        cardsTaken.add(_cards[_position]);
        _position++;
      } else {
        throw CardDepletionException(
          'Trying to take cards from a depleted deck.',
        );
      }
    }
    return cardsTaken;
  }

  @override
  String toString() {
    var result = StringBuffer();
    for (var i = 0; i < _cards.length; i += 13) {
      result.write(
        '${_cards.sublist(i, i + 13 > _cards.length ? _cards.length : i + 13).drawing}\n',
      );
    }

    return result.toString();
  }
}
