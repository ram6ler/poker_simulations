Welcome to *poker simulations*, a library for modeling poker cards, decks and hands, and for performing simulation-based poker analyses.

## Cards

A card can be instantiated using the `Card` class.

```dart
final card = Card(Face.ace, Suit.spades);
print(card.drawing);
```

```text
.--.
|A♠|
'--'
```

## Lists of cards

We generally use lists of cards over individual cards. Lists have an extension string property `drawing`, which can be helpful, particularly during debugging.

Lists of cards can be instantiated explicitly...

```dart
final cards = [
    Card(Face.two, Suit.hearts),
    Card(Face.jack, Suit.diamonds),
    Card(Face.ace, Suit.clubs),
];
print(cards.drawing);
```

```text
.--..--..--.
|2♥||J♦||A♣|
'--''--''--'
```

... or derived from a list of strings using the `toCards` extension property...

```dart
final cards = ["2h", "jd", "as"].toCards;
print(cards.drawing);
```

```text
.--..--..--.
|2♥||J♦||A♠|
'--''--''--'
```

... or directly from space or comma separated strings.

```dart
final cards = "2h jd as".toCards;
print(cards.drawing);
```

```text
.--..--..--.
|2♥||J♦||A♠|
'--''--''--'
```

## Decks

A deck of cards can be instantiated using the `Deck` class.

```dart
final deck = Deck();
print(deck);
```

```text
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|2♣||3♣||4♣||5♣||6♣||7♣||8♣||9♣||T♣||J♣||Q♣||K♣||A♣|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|2♦||3♦||4♦||5♦||6♦||7♦||8♦||9♦||T♦||J♦||Q♦||K♦||A♦|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|2♥||3♥||4♥||5♥||6♥||7♥||8♥||9♥||T♥||J♥||Q♥||K♥||A♥|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|2♠||3♠||4♠||5♠||6♠||7♠||8♠||9♠||T♠||J♠||Q♠||K♠||A♠|
'--''--''--''--''--''--''--''--''--''--''--''--''--'

```

It is sometimes helpful to have a deck with cards removed.

```dart
final deck = Deck.withCardsRemoved("2c 3d 4h 5s".toCards);
print(deck);
```

```text
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|3♣||4♣||5♣||6♣||7♣||8♣||9♣||T♣||J♣||Q♣||K♣||A♣||2♦|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|4♦||5♦||6♦||7♦||8♦||9♦||T♦||J♦||Q♦||K♦||A♦||2♥||3♥|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|5♥||6♥||7♥||8♥||9♥||T♥||J♥||Q♥||K♥||A♥||2♠||3♠||4♠|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--.
|6♠||7♠||8♠||9♠||T♠||J♠||Q♠||K♠||A♠|
'--''--''--''--''--''--''--''--''--'

```

Usually, we want a shuffled deck; the `shuffle` method returns all cards originally in the deck to the deck and shuffles them, optionally taking in a `seed` for reproducible results. 

```dart
final deck = Deck()..shuffle(seed: 0);
print(deck);
```

```text
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|3♠||3♣||K♠||9♣||8♣||Q♣||9♠||T♦||4♦||A♦||2♥||7♥||T♥|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|3♥||A♥||Q♥||9♥||9♦||7♠||2♣||J♦||8♦||T♣||K♦||J♣||Q♦|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|7♣||K♣||4♥||5♥||6♥||A♣||4♠||A♠||K♥||J♥||T♠||Q♠||5♣|
'--''--''--''--''--''--''--''--''--''--''--''--''--'
.--..--..--..--..--..--..--..--..--..--..--..--..--.
|2♠||8♠||6♠||6♦||7♦||5♠||5♦||2♦||6♣||3♦||8♥||J♠||4♣|
'--''--''--''--''--''--''--''--''--''--''--''--''--'

```

The deck keeps track of which cards have been taken and which card is at the top of the pile.

```dart
final deck = Deck()..shuffle(seed: 0);
print(deck.take(3).drawing);
print(deck.take(6).drawing);
```

```text
.--..--..--.
|3♠||3♣||K♠|
'--''--''--'
.--..--..--..--..--..--.
|9♣||8♣||Q♣||9♠||T♦||4♦|
'--''--''--''--''--''--'
```

## Hands

We can instantiate a poker hand using the `Hand` class with a list of at least five distinct cards. The instance identifies the strongest subset of five cards in the hand, and evaluates the subset.

```dart
final deck = Deck()..shuffle(seed: 0), 
  hand = Hand(deck.take(7));
print("Cards in the hand:");
print(hand.cards.drawing);
print("Best subset:");
print(hand.bestSubset.drawing);
print(hand.handType.description);
```

```text
Cards in the hand:
.--..--..--..--..--..--..--.
|3♠||3♣||K♠||9♣||8♣||Q♣||9♠|
'--''--''--''--''--''--''--'
Best subset:
.--..--..--..--..--.
|3♠||3♣||9♣||9♠||K♠|
'--''--''--''--''--'
two pairs
```

We can check whether one hand is stronger than another hand using the `beats` method, or whether it ties with another hand using `ties`.

```dart
final deck = Deck()..shuffle(seed: 0),
  hand1 = Hand(deck.take(7)),
  hand2 = Hand(deck.take(7));
print("Hand 1:");
print(hand1.cards.drawing);
print("Hand 1 best subset:");
print(hand1.bestSubset.drawing);
print("Hand 2:");
print(hand2.cards.drawing);
print("Hand 2 best subset:");
print(hand2.bestSubset.drawing);
if (hand1.beats(hand2)) {
    print("Hand 1 wins with hand: ${hand1.handType.description}!");
} else if (hand1.ties(hand2)) {
    print("A tie!");
} else {
    print("Hand 2 wins with hand: ${hand2.handType.description}!");
}
```

```text
Hand 1:
.--..--..--..--..--..--..--.
|3♠||3♣||K♠||9♣||8♣||Q♣||9♠|
'--''--''--''--''--''--''--'
Hand 1 best subset:
.--..--..--..--..--.
|3♠||3♣||9♣||9♠||K♠|
'--''--''--''--''--'
Hand 2:
.--..--..--..--..--..--..--.
|T♦||4♦||A♦||2♥||7♥||T♥||3♥|
'--''--''--''--''--''--''--'
Hand 2 best subset:
.--..--..--..--..--.
|4♦||7♥||T♦||T♥||A♦|
'--''--''--''--''--'
Hand 1 wins with hand: two pairs!
```

An instance of `Hand` has a property `strength` in the range from 0 to 9 (and a property `normalizedStrength` in the range from 0 to 1) that can be used to measure the strength of the hand. The value of `strength` is shown in the string representation of a `Hand` instance.

```dart
final deck = Deck()..shuffle(seed: 0),
  hand1 = Hand(deck.take(7)),
  hand2 = Hand(deck.take(7));
print("Hand 1:");
print(hand1);
print("Hand 2:");
print(hand2);
```

```text
Hand 1:
.--..--..--..--..--..--..--.
|3♠||3♣||K♠||9♣||8♣||Q♣||9♠|
'--''--''--''--''--''--''--'
Best set:
.--..--..--..--..--.
|3♠||3♣||9♣||9♠||K♠|
'--''--''--''--''--'
Hand Type: two pairs
Strength: 2.549635701024756
Hand 2:
.--..--..--..--..--..--..--.
|T♦||4♦||A♦||2♥||7♥||T♥||3♥|
'--''--''--''--''--''--''--'
Best set:
.--..--..--..--..--.
|4♦||7♥||T♦||T♥||A♦|
'--''--''--''--''--'
Hand Type: pair
Strength: 1.6887605041775644
```

## Simulations

Several simulation-based classes are included.

The `IncompleteHand` class can be used to model an incomplete five-card poker hand. Simulations return an instance of `StrengthStats`, which has the properties `expectation` (the expected strength of the completed hand), `variance` (the variance in the strength of the completed hand), and `distribution` (a probability distribution of the strengths of the completed hand).

```dart
final cards = "jh qh kh".toCards,
  incompleteHand = IncompleteHand(cards);
// Returns a Future<StrengthStats>
final strengthStats = await incompleteHand.strengthStats(
  simulations: 10_000, 
  seed: 0,
);
print(incompleteHand);
print("Stats:");
print(strengthStats);
```

```text
Incomplete hand:
.--..--..--.
|J♥||Q♥||K♥|
'--''--''--'
Stats:
 Expectation: 1.58418
    Variance: 1.37212
Distribution:
 [0, 1): ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░. 0.55550 nothing
 [1, 2): ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░.................... 0.35030 pair
 [2, 3): ░░................................................. 0.02620 two pairs
 [3, 4): ................................................... 0.00760 three of a kind
 [4, 5): ░░................................................. 0.02260 straight
 [5, 6): ░░░................................................ 0.03630 flush
 [6, 7): ................................................... 0.00000 full house
 [7, 8): ................................................... 0.00000 four of a kind
 [8, 9): ................................................... 0.00100 straight flush
     =9: ................................................... 0.00050 royal flush

```

Similarly, the `IncompleteHoldEmHand` class can be used to model an incomplete Texas Hold-em hand.

```dart
final incompleteHand = IncompleteHoldEmHand(
    hole: "kh ks".toCards,
    flop: "kc 2h qs".toCards,
);
// Returns a Future<StrengthStats>
final strengthStats = await incompleteHand.strengthStats(
    seed: 0,
    simulations: 5_000,
);
print(incompleteHand);
print("Stats:");
print(strengthStats);
```

```text
Incomplete Hold-em hand:
Hole:
.--..--.
|K♥||K♠|
'--''--'
Flop:
.--..--..--.
|2♥||Q♠||K♣|
'--''--''--'
Turn:
  Not dealtRiver:
  Not dealt
Stats:
 Expectation: 4.9610
    Variance: 2.1912
Distribution:
 [0, 1): ................................................... 0.0000 nothing
 [1, 2): ................................................... 0.0000 pair
 [2, 3): ................................................... 0.0000 two pairs
 [3, 4): ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░. 0.6614 three of a kind
 [4, 5): ................................................... 0.0000 straight
 [5, 6): ................................................... 0.0000 flush
 [6, 7): ░░░░░░░░░░░░░░░░░░░░░░............................. 0.2962 full house
 [7, 8): ░░░................................................ 0.0424 four of a kind
 [8, 9): ................................................... 0.0000 straight flush
     =9: ................................................... 0.0000 royal flush

```

The `FiveCardDrawHand` class can be helpful for simulating a game of five card draw poker. In particular, it can be used to help determine which cards in a hand to bin based on expected strength of the final hand.

```dart
final cards = "jc 2s 9h js td".toCards,
  hand = FiveCardDrawHand(cards);
final (:keep, :bin) = await hand.binCards(
    seed: 0, 
    simulations: 5_000,
);
print("Cards:\n${cards.drawing}");
print("Keep:\n${keep.drawing}");
print("Bin:\n${bin.drawing}");
print("Stats on keep:");
print(await IncompleteHand(keep).strengthStats(seed: 0));
```

```text
Cards:
.--..--..--..--..--.
|2♠||9♥||T♦||J♣||J♠|
'--''--''--''--''--'
Keep:
.--..--.
|J♣||J♠|
'--''--'
Bin:
.--..--..--.
|2♠||9♥||T♦|
'--''--''--'
Stats on keep:
 Expectation: 2.193
    Variance: 0.697
Distribution:
 [0, 1): ................................................... 0.000 nothing
 [1, 2): ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░. 0.716 pair
 [2, 3): ░░░░░░░░░░░........................................ 0.160 two pairs
 [3, 4): ░░░░░░░............................................ 0.114 three of a kind
 [4, 5): ................................................... 0.000 straight
 [5, 6): ................................................... 0.000 flush
 [6, 7): ................................................... 0.008 full house
 [7, 8): ................................................... 0.002 four of a kind
 [8, 9): ................................................... 0.000 straight flush
     =9: ................................................... 0.000 royal flush

```

## Thanks

Thanks for your interest in this library! Submit [issues or requests here](https://github.com/ram6ler/poker_simulations/issues).
