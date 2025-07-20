import '../core/card.dart' show Card;
import 'list_of_strings.dart' show CardsFromListOfStrings;

extension CardsFromStrings on String {
  List<Card> get toCards => this.split(RegExp(r' |, *')).toCards;
}
