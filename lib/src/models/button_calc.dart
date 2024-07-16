import 'package:currencii/src/models/calculator2.dart';
import 'package:flutter/material.dart';

class ButtonCalc {
  final String value;
  final ButtonCalcType type;
  final Color? bgColor;
  void Function(Calculator)? func;

  ButtonCalc({
    required this.value,
    required this.type,
    this.bgColor,
    this.func,
  });
}

getButtons(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return [
    ButtonCalc(
      value: 'C',
      type: ButtonCalcType.function,
      bgColor: theme.primaryColor,
      func: (Calculator calc) {
        calc.deleteAll();

      },
    ),
    ButtonCalc(
      value: '⌫',
      type: ButtonCalcType.function,
      bgColor: theme.primaryColor,
      func: (Calculator calc) {
        calc.delete();
      },
    ),
    ButtonCalc(
      value: '%',
      type: ButtonCalcType.number,
      bgColor: theme.primaryColor,
    ),
    ButtonCalc(value: '/', type: ButtonCalcType.operator, bgColor: theme.primaryColor),
    ButtonCalc(value: '7', type: ButtonCalcType.number),
    ButtonCalc(value: '8', type: ButtonCalcType.number),
    ButtonCalc(value: '9', type: ButtonCalcType.number),
    ButtonCalc(value: 'x', type: ButtonCalcType.operator, bgColor: theme.primaryColor),
    ButtonCalc(value: '4', type: ButtonCalcType.number),
    ButtonCalc(value: '5', type: ButtonCalcType.number),
    ButtonCalc(value: '6', type: ButtonCalcType.number),
    ButtonCalc(value: '-', type: ButtonCalcType.operator, bgColor: theme.primaryColor),
    ButtonCalc(value: '1', type: ButtonCalcType.number),
    ButtonCalc(value: '2', type: ButtonCalcType.number),
    ButtonCalc(value: '3', type: ButtonCalcType.number),
    ButtonCalc(value: '+', type: ButtonCalcType.operator, bgColor: theme.primaryColor),
    ButtonCalc(
        value: '+/-',
        type: ButtonCalcType.function
    ),
    ButtonCalc(value: '0', type: ButtonCalcType.number),
    ButtonCalc(value: '.', type: ButtonCalcType.number),
    ButtonCalc(
      value: '=',
      type: ButtonCalcType.function,
      bgColor: theme.primaryColorDark,
      func: (calc) {
        calc.calculate();
      },
    ),
  ];
}


enum ButtonCalcType {
  number,
  operator,
  function,
}