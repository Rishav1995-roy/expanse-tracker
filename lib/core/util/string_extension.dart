// To set Uppercase Keyboard and text field. You have to Use the [UpperCaseTextFormatter] in the [inputFormatters],
import 'package:intl/intl.dart';

extension StringExtensionFunction on String {

  String convertCurrencyInBottomSheet(double number, bool allowDecimal) {
    if (number > 999 && number < 100000) {
      if (allowDecimal) {
        NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
        return numberFormat.format(number);
      }
      NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
      return numberFormat.format(number);
    } else if (number >= 100000) {
      if (allowDecimal) {
        NumberFormat numberFormat = NumberFormat("#,##,##0.00", "en_US");
        return numberFormat.format(number);
      }
      NumberFormat numberFormat = NumberFormat("#,##,##0", "en_US");
      return numberFormat.format(number);
    } else {
      if (allowDecimal) {
        NumberFormat numberFormat = NumberFormat("##0.00", "en_US");
        return numberFormat.format(number);
      }
      NumberFormat numberFormat = NumberFormat("##0", "en_US");
      return numberFormat.format(number);
    }
  }
}
