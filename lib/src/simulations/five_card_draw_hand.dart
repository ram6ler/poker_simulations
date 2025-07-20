import 'dart:math' show Random;
import '../core/card.dart' show Card;
import '../core/deck.dart' show Deck;
import '../core/hand.dart' show Hand;
import '../exceptions/exceptions.dart' show HandLengthException;
import 'package:trotter/trotter.dart' show Combinations;

class FiveCardDrawHand {
  final List<Card> cards;
  FiveCardDrawHand(List<Card> cards) : cards = List.unmodifiable(cards) {
    if (cards.length != 5) {
      throw HandLengthException(
        'A five-card-draw hand must contain five cards',
      );
    }
  }

  Future<({List<Card> keep, List<Card> bin})> binCards({
    int? seed,
    int simulations = 1_000,
  }) async {
    final rand = Random(seed),
        deck = Deck.withCardsRemoved(cards),
        subsetsToKeep = <List<Card>>[
          for (var keep = 2; keep <= 5; keep++)
            ...Combinations<Card>(keep, cards).iterable,
        ];
    var bestSubsetIndex = -1, bestMeanStrength = 0.0;
    for (final (i, subset) in subsetsToKeep.indexed) {
      var meanStrength = 0.0;
      for (final _ in Iterable.generate(simulations)) {
        deck.shuffle(seed: rand.nextInt(1 << 32));
        final hand = Hand([...subset, ...deck.take(5 - subset.length)]);
        meanStrength += hand.strength / simulations;
      }
      if (meanStrength > bestMeanStrength) {
        bestMeanStrength = meanStrength;
        bestSubsetIndex = i;
      }
    }
    final keep = subsetsToKeep[bestSubsetIndex],
        bin = [
          for (final card in cards)
            if (!keep.contains(card)) card,
        ];
    return (keep: keep, bin: bin);
  }
}
