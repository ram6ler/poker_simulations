class BadCardFormatException {
  final String message;
  BadCardFormatException(this.message);

  @override
  String toString() => 'Bad card format: $message';
}
