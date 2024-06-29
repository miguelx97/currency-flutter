import 'package:currency_converter/src/models/calculator.dart';

class ButtonCalc {
  final String value;
  final ButtonCalcType type;
  void Function(Calculator)? func;

  ButtonCalc({
    required this.value,
    required this.type,
    this.func,
  });
}

enum ButtonCalcType {
  number,
  operator,
  function,
  error
}