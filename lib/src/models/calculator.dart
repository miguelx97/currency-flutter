import 'package:currency_converter/src/models/button_calc.dart';
import 'package:function_tree/function_tree.dart';

class Calculator {
  List<ButtonCalc> formula = [];

  add(ButtonCalc btn) {
    if (formula.isNotEmpty && formula.last.type == ButtonCalcType.error) {
      formula.clear();
    }
    switch (btn.type) {
      case ButtonCalcType.operator:
        if (formula.isEmpty || formula.last.type == ButtonCalcType.operator) {
          return;
        }
        calculate();
        if (formula.last.type == ButtonCalcType.operator) {
          formula.removeLast();
        }
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
  }

  isThereOperator() {
    return formula.any((element) => element.type == ButtonCalcType.operator);
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

  calculate() {
    String expression = formulaToString();
    expression = expression.replaceAll('x', '*');
    try {
      String result = expression.interpret().toStringAsFixed(2).replaceAll('.00', '');
      formula.clear();
      add(ButtonCalc(value: result, type: ButtonCalcType.number));
    } catch (e) {
      add(ButtonCalc(value: 'Error', type: ButtonCalcType.error));
    }
  }

  formulaToString() {
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
}