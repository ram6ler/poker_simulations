import 'dart:math' show Random, log, ln10, pow;
import '../core/types.dart' show HandType;
import '../core/card.dart' show Card;
import '../core/deck.dart' show Deck;
import '../core/hand.dart' show Hand;

class StrengthStats {
  final double expectation, variance, maxP;
  final Map<(int, int), double> distribution;
  final int digits;

  StrengthStats({
    required this.expectation,
    required this.variance,
    required this.distribution,
    required int simulations,
  }) : maxP = [
         for (final p in distribution.values) p,
       ].reduce((a, b) => a > b ? a : b),
       digits = (log(simulations) / ln10).toInt() + 1;

  @override
  String toString() {
    const barWidth = 50;
    final sb = StringBuffer();
    sb
      ..writeln(' Expectation: ${expectation.toStringAsFixed(digits)}')
      ..writeln('    Variance: ${variance.toStringAsFixed(digits)}')
      ..writeln('Distribution:');
    for (final (i, handType) in HandType.values.indexed) {
      sb
        ..write((i == 9 ? '=9: ' : '[$i, ${i + 1}): ').padLeft(9))
        ..write(
          ('░' * (barWidth * distribution[(i, i + 1)]! / maxP).toInt())
              .padRight(barWidth + 1, '.'),
        )
        ..write(' ')
        ..write(distribution[(i, i + 1)]!.toStringAsFixed(digits))
        ..writeln(' ${handType.description}');
    }
    return sb.toString();
  }
}

Future<StrengthStats> simulate({
  required Deck deck,
  required List<Card> Function(Deck) generateCards,
  required int simulations,
  int? seed,
}) async {
  final rand = Random(seed),
      strengths = [for (final _ in Iterable.generate(simulations)) 0.0],
      distribution = {for (var i = 0; i <= 9; i++) (i, i + 1): 0.0};
  for (var i = 0; i < simulations; i++) {
    deck.shuffle(seed: rand.nextInt(1 << 32));
    final hand = Hand(generateCards(deck)), j = hand.strength.floor();
    strengths[i] = hand.strength;
    distribution[(j, j + 1)] = distribution[(j, j + 1)]! + 1 / simulations;
  }
  final expectation = [
        for (final strength in strengths) strength / simulations,
      ].fold(0.0, (a, b) => a + b),
      variance = [
        for (final strength in strengths)
          pow(strength - expectation, 2) / simulations,
      ].fold(0.0, (a, b) => a + b);

  return StrengthStats(
    expectation: expectation,
    variance: variance,
    distribution: distribution,
    simulations: simulations,
  );
}
