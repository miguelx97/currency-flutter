import 'package:currency_converter/src/models/button_calc.dart';
import 'package:currency_converter/src/shared/utils.dart';
import 'package:function_tree/function_tree.dart';

class Calculator {
  List<ButtonCalc> formula = [];

  add(ButtonCalc btn, {Function? onButtonAdded}) {
    if (formula.isNotEmpty && formula.last.type == ButtonCalcType.error) {
      formula.clear();
    }
    switch (btn.type) {
      case ButtonCalcType.operator:
        if (formula.isEmpty || formula.last.type == ButtonCalcType.operator) {
          return;
        }
        calculate(onCalculate: onButtonAdded);
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

    if(onButtonAdded != null) onButtonAdded();
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
    if (formula.isEmpty || isThereOperator()) return null;
    return double.parse(formula.map((e) => e.value).join());
  }
}