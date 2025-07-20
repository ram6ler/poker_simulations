import '../core/card.dart' show Card;

String _topLayer(List<Card> cards) =>
    '${[for (final _ in cards) '.--.'].join('')}';

String _face(Card card, bool hidden) => hidden ? '|░░|' : '|$card|';

String _middleLayer(List<Card> cards, [List<int> indices = const []]) {
  final faces = [
    for (final (i, card) in cards.indexed) _face(card, indices.contains(i)),
  ];
  return faces.join('');
}

String _bottomLayer(List<Card> cards) =>
    '${[for (final _ in cards) "'--'"].join('')}';

extension StringsFromListOfCards on List<Card> {
  /// A string representation of a list of cards, mainly for debugging.
  ///
  /// Example:
  ///
  /// ```dart
  /// print(
  ///   [
  ///     Card(Face.two, Suit.hearts),
  ///     Card(Face.queen, Suit.diamonds),
  ///     Card(Face.ace, Suit.clubs),
  ///     Card(Face.jack, Suit.spades),
  ///   ].drawing,
  /// );
  /// ```
  /// Result:
  ///
  /// ```text
  /// .--..--..--..--.
  /// |2♥||Q♦||A♣||J♠|
  /// '--''--''--''--'
  /// ```
  String get drawing =>
      '${_topLayer(this)}\n'
      '${_middleLayer(this)}\n'
      '${_bottomLayer(this)}';

  /// A string representation of a list of cards with some of the
  /// cards face down, mainly for debugging.
  ///
  /// Example:
  ///
  /// ```dart
  /// final deck = Deck()..shuffle(), cards = deck.take(5);
  ///   print(cards.drawing);
  ///   print(cards.drawingWithHidden([0, 2, 4]));
  /// ```
  /// Result:
  ///
  /// ```text
  /// .--..--..--..--..--.
  /// |5♠||J♠||A♣||3♦||8♠|
  /// '--''--''--''--''--'
  /// .--..--..--..--..--.
  /// |░░||J♠||░░||3♦||░░|
  /// '--''--''--''--''--'
  /// ```

  String drawingWithHidden(List<int> indices) =>
      '${_topLayer(this)}\n'
      '${_middleLayer(this, indices)}\n'
      '${_bottomLayer(this)}';

  /// A list of string representation of the cards.
  List<String> get asListOfStrings => [
    for (final card in this) '${card.face.character}${card.suit.character}',
  ];

  /// A string representation of the cards.
  String get asString => asListOfStrings.join(", ");
}
