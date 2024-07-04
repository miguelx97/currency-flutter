import 'dart:convert';

import 'package:currency_converter/src/models/calculator.dart';
import 'package:currency_converter/src/models/currency_conversion_request.dart';
import 'package:currency_converter/src/shared/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Conversor {
  String? fromCurrency;
  String? toCurrency;
  double? value1;
  double? conversionRate;
  double? value2;

  Conversor({
    this.fromCurrency,
    this.toCurrency,
    this.value1 = 0,
    this.conversionRate,
    this.value2 = 0,
  });

  String convert(Calculator calc, {bool reverse = false}) {
    double? number = calc.getNumberToConvert();
    return reverse ? reverseConvert(number) : directConvert(number);
  }

  directConvert(double? number) {
    if (number != null) {
      value1 = number;
      value2 = roundNumber(value1! * conversionRate!);
    }
    return roundNumberStr(value2!);
  }

  reverseConvert(double? number) {
    if (number != null) {
      value2 = number;
      value1 = roundNumber(value2! / conversionRate!);
    }
    return roundNumberStr(value2!);
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