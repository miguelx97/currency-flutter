import 'package:currencii/src/models/button_calc.dart';
import 'package:currencii/src/shared/utils.dart';
import 'package:function_tree/function_tree.dart';

class Calculator {
  List<ButtonCalc> formula = [];

  add(ButtonCalc btn, {Function? onButtonAdded}) {
    if (formula.isNotEmpty && formula.last.type == ButtonCalcType.error) {
      formula.clear();
    }
    switch (btn.type) {
      case ButtonCalcType.operator:
        if (formula.isEmpty) return;
        if (isLastOperator() && btn.value != '-') {
          formula.removeLast();
        }
        if(isThereOperator() && !isLastOperator()) calculate(onCalculate: onButtonAdded);
        formula.add(btn);
        break;
      case ButtonCalcType.number:
        if (formula.isNotEmpty && formula.last.type == ButtonCalcType.number) {
          String lastValue = formula.last.value;
          lastValue += btn.value;
          replaceLastNumber(lastValue);
        } else {
          formula.add(btn);
        }
        break;
      case ButtonCalcType.function:
        btn.func!(this);
        break;
      case ButtonCalcType.error:
        formula.clear();
        formula.add(btn);
        break;
    }

    if(onButtonAdded != null) onButtonAdded();
  }

  isThereOperator() {
    return formula.any((element) => element.type == ButtonCalcType.operator);
  }

  isLastOperator() {
    return formula.isNotEmpty && formula.last.type == ButtonCalcType.operator;
  }

  replaceLastNumber(String value) {
    formula.removeLast();
    formula.add(ButtonCalc(value: value, type: ButtonCalcType.number));
  }

  delete() {
    String lastValue = formula.last.value;
    if (lastValue.length > 1) {
      replaceLastNumber(lastValue.substring(0, lastValue.length - 1));
    } else {
      formula.removeLast();
    }
  }

  deleteAll() {
    formula.clear();
  }

  calculate({Function? onCalculate}) {
    String expression = formulaToString();
    expression = expression.replaceAll('x', '*');
    try {
      String result = roundNumberStr(expression.interpret().toDouble());
      formula.clear();
      add(ButtonCalc(value: result, type: ButtonCalcType.number));
    } catch (e) {
      add(ButtonCalc(value: 'Error', type: ButtonCalcType.error));
    }
  }

  String formulaToString() {
    if (formula.isEmpty) return '0';
    return formula.map((e) {
      switch (e.type) {
        case ButtonCalcType.number:
        case ButtonCalcType.error:
          return e.value;
        case ButtonCalcType.operator:
          return ' ${e.value} ';
        case ButtonCalcType.function:
          return '';
      }
    }).join();
  }

  double? getNumberToConvert() {
    if(formula.isEmpty) return 0;
    List<ButtonCalc> formulaAux = List.from(formula);
    if (formulaAux.last.type == ButtonCalcType.operator) {
      formulaAux.removeLast();
    }
    bool isThereOperator = formulaAux.any((element) => element.type == ButtonCalcType.operator);
    if(isThereOperator) return null;
    try {
      return double.parse(formulaAux.map((e) => e.value).join());
    } catch (e) {
      return 0;
    }
  }
}