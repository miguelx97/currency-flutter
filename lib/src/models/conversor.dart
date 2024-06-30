import 'package:currency_converter/src/models/calculator.dart';

class Conversor {
  final String? currencyOne;
  final String? currencyTwo;
  final double? valueOne;
  final double? conversionRate;
  final double? result;

  Conversor({
    this.currencyOne,
    this.currencyTwo,
    this.valueOne,
    this.conversionRate,
    this.result,
  });

  String convert(Calculator calc) {
    if(calc.formula.isEmpty) return '0';
    if(calc.isThereOperator()) return '0';
    return (double.parse(calc.formulaToString()) * conversionRate!).toStringAsFixed(2).replaceAll('.00', '');
  }

  String reverseConvert(Calculator calc) {
    if(calc.formula.isEmpty) return '0';
    if(calc.isThereOperator()) return '0';
    return (double.parse(calc.formulaToString()) / conversionRate!).toStringAsFixed(2).replaceAll('.00', '');
  }
}