
import 'formatter.dart';

extension PriceParsing on int {
  String toPrice() {
    return "R${UtilFormatter.formatNumber(this)}";
  }
}
