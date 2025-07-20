import 'dart:math' show pow;
import 'package:trotter/trotter.dart' show Combinations;
import 'card.dart' show Card;
import 'types.dart' show Face, HandType, Strength;
import '../extensions/list_of_cards.dart' show StringsFromListOfCards;
import '../exceptions/exceptions.dart' show HandLengthException;

/// Miniscule value to prevent the maximum strength of one
/// hand type to overlap the set of strengths for the next
/// hand type.
const _epsilon = 1e-6;

/// Helper to calculate he maximum hand type score for the
/// respective hand types in _maxStrength.
int _maxScore(int places) => [
  for (var i = 0; i < places; i++) 12 * pow(13, i),
].fold(0.0, (a, b) => a + b).toInt();

/// The maximum scores that can be obtained for a given
/// hand type.
final _maxScores = {
  HandType.nothing: _maxScore(5),
  HandType.pair: _maxScore(4),
  HandType.twoPair: _maxScore(3),
  HandType.threeOfAKind: _maxScore(3),
  HandType.straight: _maxScore(1),
  HandType.flush: _maxScore(5),
  HandType.fullHouse: _maxScore(2),
  HandType.fourOfAKind: _maxScore(2),
  HandType.straightFlush: _maxScore(1),
  HandType.royalFlush: _maxScore(0),
};

/// Maps the strength of a hand of given hand type and score
/// to the set [0, 1).
Strength _strength(HandType handType, int handScore) =>
    (handType.index + handScore / (_maxScores[handType]! + _epsilon));

/// Determines the strongest subset of cards in the hand and
/// returns its hand type, strength and the subset itself.
(HandType, Strength, List<Card>) _evaluate(List<Card> cards) {
  var bestHandType = HandType.nothing,
      bestScore = 0,
      bestCombination = <Card>[];

  void updateBestIfNecessary(
    HandType handType,
    int score,
    List<Card> combination,
  ) {
    if (handType.index > bestHandType.index ||
        (handType.index == bestHandType.index && score > bestScore)) {
      bestHandType = handType;
      bestScore = score;
      bestCombination = combination;
    }
  }

  for (final combination in Combinations<Card>(5, cards).iterable) {
    /// The face counts in the combination of cards.
    final counts = {for (final card in combination) card.face: 0};
    for (final card in combination) counts[card.face] = counts[card.face]! + 1;

    final hasStraight = (() {
          final ranks = [for (final card in combination) card.face.index]
            ..sort();
          bool checkRanks() => [
            for (var i = 0; i < 5; i++) ranks[i] - ranks.first == i,
          ].every((x) => x);
          if (checkRanks()) return true;
          // In case ace low...
          final index = ranks.indexOf(Face.ace.index);
          if (index != -1) {
            ranks[index] = -1;
            ranks.sort();
            return checkRanks();
          }
          return false;
        })(),
        hasFlush = {for (final card in combination) card.suit}.length == 1,
        hasPair = counts.values.any((f) => f == 2),
        hasFourOfAKind = counts.values.any((f) => f == 4),
        hasThreeOfAKind = counts.values.any((f) => f == 3),
        hasFullHouse = hasPair && hasThreeOfAKind,
        hasTwoPairs = (() {
          var pairs = 0;
          for (final f in counts.values) if (f == 2) pairs++;
          return pairs == 2;
        })();

    if (hasStraight && hasFlush) {
      final ranks = [for (final card in combination) card.face.index];
      if (ranks.contains(Face.ace.index) && ranks.contains(Face.two.index)) {
        final index = ranks.indexOf(Face.ace.index);
        ranks[index] = -1;
      }
      final score = ranks.fold(ranks.first, (a, b) => b > a ? b : a);
      if (score == Face.ace.index)
        updateBestIfNecessary(HandType.royalFlush, 0, combination);
      else
        updateBestIfNecessary(HandType.straightFlush, score, combination);
    } else if (hasFourOfAKind) {
      var four = -1, single = -1;
      for (final MapEntry(key: rank, value: frequency) in counts.entries) {
        if (frequency == 4) four = rank.index;
        if (frequency == 1) single = rank.index;
      }
      final score = four * 13 + single;
      updateBestIfNecessary(HandType.fourOfAKind, score, combination);
    } else if (hasFullHouse) {
      var triple = -1, double = -1;
      for (final MapEntry(key: rank, value: frequency) in counts.entries) {
        if (frequency == 3) triple = rank.index;
        if (frequency == 2) double = rank.index;
      }
      final score = triple * 13 + double;
      updateBestIfNecessary(HandType.fullHouse, score, combination);
    } else if (hasFlush) {
      final ranks = [for (final card in combination) card.face.index]..sort(),
          score = [
            for (final (i, rank) in ranks.indexed) pow(13, i) * rank,
          ].fold(0.0, (a, b) => a + b).toInt();
      updateBestIfNecessary(HandType.flush, score, combination);
    } else if (hasStraight) {
      final ranks = [for (final card in combination) card.face.index],
          score =
              ranks.contains(Face.ace.index) && ranks.contains(Face.two.index)
              ? Face.five.index
              : ranks.fold(-1, (a, b) => b > a ? b : a);
      updateBestIfNecessary(HandType.straight, score, combination);
    } else if (hasThreeOfAKind) {
      final three = [
            for (final face in counts.keys)
              if (counts[face] == 3) face.index,
          ].first,
          ranks = [
            for (final face in counts.keys)
              if (counts[face] == 1) face.index,
          ]..sort(),
          score = three * 13 * 13 + ranks[1] * 13 + ranks.first;
      updateBestIfNecessary(HandType.threeOfAKind, score, combination);
    } else if (hasTwoPairs) {
      final pairs = [
            for (final face in counts.keys)
              if (counts[face] == 2) face.index,
          ]..sort(),
          single = [
            for (final face in counts.keys)
              if (counts[face] == 1) face.index,
          ].first,
          score = pairs[1] * 13 * 13 + pairs.first * 13 + single;
      updateBestIfNecessary(HandType.twoPair, score, combination);
    } else if (hasPair) {
      final pair = [
            for (final face in counts.keys)
              if (counts[face] == 2) face.index,
          ].first,
          singles = [
            for (final face in counts.keys)
              if (counts[face] == 1) face.index,
          ]..sort(),
          score =
              (pair * pow(13, 3) +
                      [
                        for (final (i, rank) in singles.indexed)
                          rank * pow(13, i),
                      ].fold(0.0, (a, b) => a + b))
                  .toInt();
      updateBestIfNecessary(HandType.pair, score, combination);
    } else {
      final singles = [
            for (final face in counts.keys)
              if (counts[face] == 1) face.index,
          ]..sort(),
          score = [
            for (final (i, rank) in singles.indexed) rank * pow(13, i),
          ].fold(0.0, (a, b) => a + b).toInt();
      updateBestIfNecessary(HandType.nothing, score, combination);
    }
  }
  final strength = _strength(bestHandType, bestScore),
      faces = [for (final card in bestCombination) card.face],
      aceIsLow = bestHandType == HandType.straight && faces.contains(Face.two);

  return (
    bestHandType,
    strength,
    bestCombination..sort(
      (a, b) => (a.face == Face.ace && aceIsLow ? -1 : a.face.index).compareTo(
        b.face.index,
      ),
    ),
  );
}

class Hand {
  final List<Card> _cards;
  List<Card> get cards => _cards;
  late final (HandType, Strength, List<Card>) _evaluation;

  /// A hand consisting of at least five cards.
  Hand(List<Card> cards) : _cards = List<Card>.unmodifiable(cards.toSet()) {
    if (cards.length < 5)
      throw HandLengthException('Hand must contain at least five cards');
    _evaluation = _evaluate(cards);
  }

  /// The hand type of the best subset of cards in the hand.
  HandType get handType {
    final (result, _, _) = _evaluation;
    return result;
  }

  /// The strength of the best subset of cards in the hand on a scale
  /// from 0 to 9, such that if (and only if) the score of hand A is
  /// greater than that of hand B, then hand A beats hand B according
  /// to the standard poker hand rankings. If two hands tie, they have
  /// the same strength.
  ///
  /// |Subset Hand Type|Floor|
  /// |:--|:--:|
  /// |Nothing|0|
  /// |Pair|1|
  /// |Two pairs|2|
  /// |Three of a kind|3|
  /// |Straight|4|
  /// |Flush|5|
  /// |Full house|6|
  /// |Four of a kind|7|
  /// |Straight flush|8|
  /// |Royal flush|9|
  ///
  Strength get strength {
    final (_, result, _) = _evaluation;
    return result;
  }

  /// The strength of the best subset of cards in the hand, normalized to
  /// lie between 0 and 1.
  Strength get normalizedStrength {
    return strength / (HandType.royalFlush.index + _epsilon);
  }

  /// The strongest subset of cards in the hand.
  List<Card> get bestSubset {
    final (_, _, result) = _evaluation;
    return result;
  }

  /// Whether this hand beats another hand.
  bool beats(Hand that) => strength > that.strength;

  /// Whether this hand ties with another hand.
  bool ties(Hand that) => strength == that.strength;

  @override
  String toString() {
    return '${_cards.drawing}\n'
        'Best set:\n${bestSubset.drawing}\n'
        'Hand Type: ${handType.description}\n'
        'Strength: $strength';
  }
}
