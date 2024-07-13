import 'package:currencii/src/models/calculator.dart';
import 'package:currencii/src/shared/colors.dart';
import 'package:currencii/src/shared/utils.dart';
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

getButtons() {
  return [
    ButtonCalc(
      value: 'C',
      type: ButtonCalcType.function,
      bgColor: ColorTheme.primary,
      func: (Calculator calc) {
        calc.deleteAll();

      },
    ),
    ButtonCalc(
      value: '⌫',
      type: ButtonCalcType.function,
      bgColor: ColorTheme.primary,
      func: (Calculator calc) {
        calc.delete();
      },
    ),
    ButtonCalc(
      value: '%',
      type: ButtonCalcType.function,
      bgColor: ColorTheme.primary,
      func: (calc) {
        String lastValue = calc.formula.last.value;
        lastValue = roundNumberStr(double.parse(lastValue) / 100);
        calc.replaceLastNumber(lastValue);
      },
    ),
    ButtonCalc(value: '/', type: ButtonCalcType.operator, bgColor: ColorTheme.primary),
    ButtonCalc(value: '7', type: ButtonCalcType.number),
    ButtonCalc(value: '8', type: ButtonCalcType.number),
    ButtonCalc(value: '9', type: ButtonCalcType.number),
    ButtonCalc(value: 'x', type: ButtonCalcType.operator, bgColor: ColorTheme.primary),
    ButtonCalc(value: '4', type: ButtonCalcType.number),
    ButtonCalc(value: '5', type: ButtonCalcType.number),
    ButtonCalc(value: '6', type: ButtonCalcType.number),
    ButtonCalc(value: '-', type: ButtonCalcType.operator, bgColor: ColorTheme.primary),
    ButtonCalc(value: '1', type: ButtonCalcType.number),
    ButtonCalc(value: '2', type: ButtonCalcType.number),
    ButtonCalc(value: '3', type: ButtonCalcType.number),
    ButtonCalc(value: '+', type: ButtonCalcType.operator, bgColor: ColorTheme.primary),
    ButtonCalc(
        value: '+/-',
        type: ButtonCalcType.function,
        func: (calc) {
          if(calc.formula.isEmpty || calc.isLastOperator() == ButtonCalcType.operator) return;
          String lastValue = calc.formula.last.value;
          if (lastValue.startsWith('-')) {
            calc.replaceLastNumber(lastValue.substring(1));
          } else {
            calc.replaceLastNumber('-$lastValue');
          }
        }),
    ButtonCalc(value: '0', type: ButtonCalcType.number),
    ButtonCalc(value: '.', type: ButtonCalcType.number),
    ButtonCalc(
      value: '=',
      type: ButtonCalcType.function,
      bgColor: ColorTheme.primaryDark,
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
  error
}