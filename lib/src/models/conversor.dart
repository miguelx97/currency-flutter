import 'dart:convert';

import 'package:currency_converter/src/models/calculator.dart';
import 'package:currency_converter/src/models/currency_conversion_request.dart';
import 'package:currency_converter/src/shared/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Conversor {
  String? fromCurrency;
  String? toCurrency;
  double? value;
  double? conversionRate;
  double? result;

  Conversor({
    this.fromCurrency,
    this.toCurrency,
    this.value,
    this.conversionRate,
    this.result,
  });

  String convert(Calculator calc, {bool reverse = false}) {
    if (calc.formula.isEmpty) return '0';
    if (!calc.isThereOperator()) {
      value = calc.getResultNumber();
      double conversionRate = reverse ? 1 / this.conversionRate! : this.conversionRate!;
      result = roundNumber(value! * conversionRate);
    }
    return roundNumberStr(result!);
  }

  Future<void> selectCurrency(String fromCurrency, String toCurrency) async {
    final String url = 'https://v6.exchangerate-api.com/v6/42e34072e37619ccfc32f0be/pair/$toCurrency/$fromCurrency';

    // set the values
    this.fromCurrency = fromCurrency;
    this.toCurrency = toCurrency;

    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      CurrencyConversionRequest c = CurrencyConversionRequest.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      conversionRate = c.conversionRate;
      print('Conversion rate: $conversionRate');
    }

    
  }
}