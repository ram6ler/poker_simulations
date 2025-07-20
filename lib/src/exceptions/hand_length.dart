class HandLengthException {
  final String message;
  HandLengthException(this.message);
  @override
  String toString() => 'Hand length: $message';
}
