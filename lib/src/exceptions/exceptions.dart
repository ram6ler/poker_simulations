abstract class PokerException {
  final String message;
  PokerException(this.message);
}

class CardDepletionException extends PokerException {
  CardDepletionException(super.message);

  @override
  String toString() => "Card Depletion: $message";
}

class BadCardFormatException extends PokerException {
  BadCardFormatException(super.message);

  @override
  String toString() => 'Bad Card Format: $message';
}

class HandLengthException extends PokerException {
  HandLengthException(super.message);

  @override
  String toString() => 'Hand Length: $message';
}
