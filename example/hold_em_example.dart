import 'package:poker_simulations/poker_simulations.dart';

Future<void> main() async {
  final hole = <Card>[],
      flop = <Card>[],
      turn = <Card>[],
      river = <Card>[],
      deck = Deck()..shuffle();

  Future<void> showBreakdown() async {
    print(
      await IncompleteHoldEmHand(
        hole: hole,
        flop: flop,
        turn: turn,
        river: river,
      ).strengthStats(),
    );
  }

  print("Dealing the hole...");
  hole.addAll(deck.take(2));
  print(hole.drawing);
  await showBreakdown();

  print("Dealing the flop...");
  flop.addAll(deck.take(3));
  print(flop.drawing);
  await showBreakdown();

  print("Dealing the turn...");
  turn.addAll(deck.take(1));
  print(turn.drawing);
  await showBreakdown();

  print("Dealing the river...");
  river.addAll(deck.take(1));
  print(river.drawing);

  print("\nFinal result:");
  print(Hand([...hole, ...flop, ...turn, ...river]));
}
