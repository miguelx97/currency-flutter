import 'package:currencii/src/models/button_calc.dart';
import 'package:currencii/src/shared/utils.dart';
import 'package:function_tree/function_tree.dart';

class Calculator {
  // string para la formula
  // checks
  // get first number

  String _expression = '';

  get formatedExpression{
    if(isEmpty) return '0';

      // Expresión regular para encontrar todos los números en la cadena.
      RegExp regExp = RegExp(r'\d+(\.\d+)?');

      // Función para formatear el número encontrado.
      String formatMatch(Match match) {
        double number = double.parse(match.group(0)!);
        return format(number);
      }

    // Reemplazar todos los números en la cadena.
    String formattedString = _expression.replaceAllMapped(regExp, (match) => formatMatch(match));
    return formattedString;
  }
  get isEmpty => _expression.isEmpty;

  setValue(double? number) {
    _expression = number?.toString() ?? '0';
  }

  // regex to return the first number in the expression (include negative numbers and decimals)
  double get firstNumber {
    RegExp regExpFirst = RegExp(r'-?\d+(\.\d+)?');
    String firstNumber = regExpFirst.stringMatch(_expression) ?? '0';
    return double.parse(firstNumber);
  }

  isLastOperator() {
    return !isEmpty && RegExp(r'[+x/-]$').hasMatch(_expression);
  }

  deleteOperators() {
    // delete all operators and blank spaces from the end of the string until the first number
    _expression = _expression.replaceAll(RegExp(r'[+x/-]\s*$'), '');
  }

  isThereOperator() {
    return RegExp(r'[+x/-]').hasMatch(_expression);
  }

  add(ButtonCalc btn, {Function? onButtonAdded}){
    switch (btn.type) {
      case ButtonCalcType.operator:
        if (isEmpty) return;
        if (isLastOperator() && btn.value != '-') deleteOperators();

        if(isThereOperator() && !isLastOperator()) calculate();
        _expression += btn.value;
        break;
      case ButtonCalcType.number:
          _expression += btn.value;
        break;
      case ButtonCalcType.function:
        btn.func!(this);
        break;
    }

    if (onButtonAdded != null) onButtonAdded();
  }

  calculate() {
    String expressionAux = _expression.replaceAll('x', '*');
    expressionAux = expressionAux.replaceAll('%', '/100');
    expressionAux = expressionAux.replaceAll(',', '');

    try {
      _expression = expressionAux.interpret().toString();
    } catch (e) {
      _expression = 'Error';
    }
  }

  delete() {
    if (isEmpty) {
      return;
    } else if (isLastOperator()) {
      deleteOperators();
    } else {
      _expression = _expression.substring(0, _expression.length - 1);
    }
  }

  deleteAll() {
    _expression = '';
  }
}