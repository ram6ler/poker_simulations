import 'package:poker_simulations/poker_simulations.dart';

void main() {
  final deck = Deck()..shuffle();
  print('The deck:');
  print(deck);
  print('Taking seven cards:');
  final cards = deck.take(7);
  print(Hand(cards));
}
