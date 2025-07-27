import 'dart:math' show min;
import 'package:poker_simulations/poker_simulations.dart';

void main() {
  {
    final deck = Deck()..shuffle();
    for (final t in [1, 3, 5, 2]) {
      print('Taking $t cards...');
      print(deck.take(t).drawing);
    }
    print('Cards taken so far:');
    print(deck.cardsRemoved.drawing);
    print('Cards remaining:');
    final remaining = deck.cardsRemaining;
    for (var i = 0; i < remaining.length; i += 10) {
      print(remaining.sublist(i, min(i + 10, remaining.length)).drawing);
    }
  }

  {
    final deck = Deck.withCards('as 5d 2c kh'.toCards);
    print(deck.take(3).drawing);
    print(deck.cardsRemoved.drawing);
    print(deck.cardsRemaining.drawing);
  }
}
