import '../core/card.dart' show Card;
import '../core/types.dart' show Face, Suit;
import '../exceptions/bad_card_format.dart' show BadCardFormatException;

const _faces = {
      '2': Face.two,
      '3': Face.three,
      '4': Face.four,
      '5': Face.five,
      '6': Face.six,
      '7': Face.seven,
      '8': Face.eight,
      '9': Face.nine,
      't': Face.ten,
      'j': Face.jack,
      'q': Face.queen,
      'k': Face.king,
      'a': Face.ace,
    },
    _suits = {
      'c': Suit.clubs,
      'd': Suit.diamonds,
      'h': Suit.hearts,
      's': Suit.spades,
    };

extension CardsFromListOfStrings on List<String> {
  List<Card> get toCards {
    final cards = <Card>[];
    for (final cardString in [for (final c in this) c.trim()]) {
      if (cardString.length != 2)
        throw BadCardFormatException(
          'Card strings are expected to be of length 2; '
          "received '$cardString'",
        );
      final (f, s) = (cardString[0].toLowerCase(), cardString[1].toLowerCase());
      if (!_faces.containsKey(f))
        throw BadCardFormatException(
          'Faces are expected to be in the set '
          "'2', '3', ..., 't', 'j', 'q', 'k', 'a'; received '$f'",
        );
      if (!_suits.containsKey(s))
        throw BadCardFormatException(
          'Suits are expected to be in the set '
          "'c', 'd', 'h', 's'; received '$s'",
        );
      cards.add(Card(_faces[f]!, _suits[s]!));
    }

    return cards.toSet().toList()
      ..sort((a, b) => a.face.index.compareTo(b.face.index));
  }
}
