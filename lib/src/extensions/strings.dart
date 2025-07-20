import '../core/card.dart' show Card;
import 'list_of_strings.dart' show CardsFromListOfStrings;

extension CardsFromStrings on String {
  List<Card> get toCards => split(RegExp(r' |, *')).toCards;
}
