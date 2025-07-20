import 'strength_stats.dart' show simulate, StrengthStats;
import '../core/card.dart' show Card;
import '../core/deck.dart' show Deck;
import '../extensions/list_of_cards.dart' show StringsFromListOfCards;
import '../exceptions/exceptions.dart' show HandLengthException;

class IncompleteHand {
  final List<Card> cards;
  IncompleteHand(List<Card> cards) : cards = List.unmodifiable(cards) {
    if (cards.length >= 5)
      throw HandLengthException(
        'An incomplete hand must have fewer than five cards',
      );
  }

  Future<StrengthStats> strengthStats({
    int? seed,
    int simulations = 1_000,
  }) async => await simulate(
    deck: Deck.withCardsRemoved(cards),
    generateCards: (deck) => [...cards, ...deck.take(5 - cards.length)],
    simulations: simulations,
    seed: seed,
  );

  @override
  String toString() => 'Incomplete hand:\n${cards.drawing}';
}
