import 'package:poker_simulations/poker_simulations.dart';

void main() {
  print('asListOfStrings...');
  final listOfStrings = ['jd', 'as', '3h', 'kc'];
  print(
    '  listOfStrings:     '
    '$listOfStrings',
  );
  print(
    '  Represented cards: '
    '${listOfStrings.toCards}',
  );
  print(
    '  Inverse:           '
    '${listOfStrings.toCards.asListOfStrings}',
  );
  print(
    '  Cards:             '
    '${listOfStrings.toCards.asListOfStrings.toCards}',
  );

  print('\nasString...');
  final string = 'jd as 3h kc';
  print(
    '  string:            '
    '$string',
  );
  print(
    '  Represented cards: '
    '${string.toCards}',
  );
  print(
    '  Inverse:           '
    '${string.toCards.asString}',
  );
  print(
    '  Cards:             '
    '${string.toCards.asString.toCards}',
  );
}
