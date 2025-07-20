import 'package:poker_simulations/poker_simulations.dart';

void main() {
  final deck = Deck()..shuffle(),
      hands = [for (final _ in Iterable.generate(6)) Hand(deck.take(8))]
        ..sort((a, b) => a.strength.compareTo(b.strength));
  for (final hand in hands) {
    print('Hand:\n$hand\n\n');
  }
}
