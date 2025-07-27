import 'dart:math' show log;
import 'package:poker_simulations/poker_simulations.dart';

/// Shannon entropy of the cards in the deck; well shuffled decks
/// have an entropy somewhere between 3 and 3.5.
/// See https://stats.stackexchange.com/q/79552.
double entropy(Deck deck) {
  final cards = deck.cards;

  final histogram = [for (final _ in Iterable.generate(52)) 0.0];
  for (var i = 0; i < 52; i++) {
    final difference = (cards[(i + 1) % 52].index - cards[i].index) % 52;
    histogram[difference] += 1 / 52;
  }
  return -[
    for (final p in histogram)
      if (p > 0.0) p * log(p),
  ].fold(0.0, (a, b) => a + b);
}

void draw(Deck deck) {
  print(deck);
  print('Entropy: ${entropy(deck).toStringAsFixed(3)}');
}

void main() {
  final deck = Deck();
  print('Before shuffling:');
  draw(deck);

  deck.shuffle();
  print('\nAfter shuffling:');
  draw(deck);
}
