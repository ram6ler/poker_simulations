import 'package:poker_simulations/poker_simulations.dart';

Future<void> main() async {
  final deck = Deck();
  for (final _ in Iterable.generate(10)) {
    deck.shuffle();
    final cards = deck.take(5);
    final (:bin, :keep) = await FiveCardDrawHand(cards).binCards();
    print('Cards:\n${cards.drawing}');
    print('Keep:\n${keep.drawing}');
    print('Bin:\n${bin.drawing}\n\n');
  }
}
