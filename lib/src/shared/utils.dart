import 'package:intl/intl.dart';

  String format(double? value) {
    if (value == null) return '0';
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
    );
    return formatter.format(value).replaceFirst(RegExp(r'\.?0*$'), '');
  }

  extension StringExtensions on String {
  String _normalize() {
    return toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u');
  }

  bool containsIgnoreCase(String other) {
    return _normalize().contains(other._normalize());
  }
}