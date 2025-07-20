import 'strength_stats.dart' show StrengthStats, simulate;
import '../core/card.dart' show Card;
import '../core/deck.dart' show Deck;
import '../extensions/list_of_cards.dart' show StringsFromListOfCards;
import '../exceptions/exceptions.dart' show HandLengthException;

class IncompleteHoldEmHand {
  final List<Card> hole, flop, turn, river;
  IncompleteHoldEmHand({
    this.hole = const [],
    this.flop = const [],
    this.turn = const [],
    this.river = const [],
  }) {
    if (hole.isNotEmpty && hole.length != 2)
      throw HandLengthException(
        'The hole must be empty or have two cards; '
        'received:\n${hole.drawing}',
      );
    if (flop.isNotEmpty && flop.length != 3)
      throw HandLengthException(
        'The flop must be empty or have three cards; '
        'received:\n${flop.drawing}',
      );
    if (turn.isNotEmpty && turn.length != 1)
      throw HandLengthException(
        'The turn must be empty or have one card; '
        'received:\n${turn.drawing}',
      );
    if (river.isNotEmpty && river.length != 1)
      throw HandLengthException(
        'The river must be empty or have one card; '
        'received:\n${river.drawing}',
      );

    final duplicateCheck = [...hole, ...flop, ...turn, ...river];
    if (duplicateCheck.toSet().length != duplicateCheck.length)
      throw HandLengthException(
        'The hand cannot contain duplicate cards; '
        'received:\n${duplicateCheck.drawing}',
      );
  }

  /// The cards in the hole plus the communal cards.
  List<Card> get cards => [...hole, ...flop, ...turn, ...river];

  Future<StrengthStats> strengthStats({
    int? seed,
    int simulations = 1_000,
  }) async => await simulate(
    deck: Deck.withCardsRemoved([...hole, ...flop, ...turn, ...river]),
    generateCards: (deck) {
      final virtualHole = hole.isEmpty ? deck.take(2) : hole,
          virtualFlop = flop.isEmpty ? deck.take(3) : flop,
          virtualTurn = turn.isEmpty ? deck.take(1) : turn,
          virtualRiver = river.isEmpty ? deck.take(1) : river;
      return [...virtualHole, ...virtualFlop, ...virtualTurn, ...virtualRiver];
    },
    simulations: simulations,
    seed: seed,
  );

  @override
  String toString() {
    final pockets = [
          ('Hole', hole),
          ('Flop', flop),
          ('Turn', turn),
          ('River', river),
        ],
        sb = StringBuffer('Incomplete Hold-em hand:\n');
    for (final (title, cards) in pockets) {
      sb
        ..writeln('$title:')
        ..write(cards.isEmpty ? '  Not dealt\n' : '${cards.drawing}\n');
    }
    return sb.toString();
  }
}
