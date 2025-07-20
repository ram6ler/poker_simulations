import 'package:poker_simulations/poker_simulations.dart';

class Player {
  final cards = <Card>[];
}

Future<void> main() async {
  const noOfPlayers = 4;
  final deck = Deck()..shuffle(seed: 0),
      players = [for (final _ in Iterable.generate(noOfPlayers)) deck.take(5)];

  for (final (i, cards) in players.indexed) {
    print('\nPlayer ${i + 1}:');
    print('Cards:');
    print(cards.drawing);
    final (:keep, :bin) = await FiveCardDrawHand(cards).binCards(seed: 0);
    print('Keeps:');
    print(keep.drawing);
    print('Bins:');
    print(bin.drawing);
    final newCards = deck.take(5 - keep.length);
    cards
      ..removeWhere(bin.contains)
      ..addAll(newCards);
    print('New cards:');
    print(newCards.drawing);
  }
  final hands = [for (final (i, cards) in players.indexed) (i, Hand(cards))]
    ..sort((a, b) => b.$2.strength.compareTo(a.$2.strength));

  print('\nResults:');
  for (final (i, (j, hand)) in hands.indexed) {
    print(
      '\n${i + 1}${switch (i) {
        0 => 'st',
        1 => 'nd',
        2 => 'rd',
        _ => 'th',
      }} place: '
      'Player ${j + 1}',
    );
    print(hand.bestSubset.drawing);
    print(hand.handType.description);
    print(hand.strength);
  }
}
