import 'package:intl/intl.dart';

  String format(double? value) {
    if (value == null) return '0';
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
    );
    return formatter.format(value).replaceFirst(RegExp(r'\.?0*$'), '');
  }