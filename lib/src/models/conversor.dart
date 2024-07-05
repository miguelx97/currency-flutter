import 'dart:convert';

import 'package:currency_converter/src/models/calculator.dart';
import 'package:currency_converter/src/models/currency.dart';
import 'package:currency_converter/src/models/currency_conversion_request.dart';
import 'package:currency_converter/src/services/currencies.service.dart';
import 'package:currency_converter/src/services/lib/services/local_storage.service.dart';
import 'package:currency_converter/src/shared/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Conversor extends LsParser<Conversor>{
  Currency? fromCurrency;
  Currency? toCurrency;
  double? value1;
  double? conversionRate;
  double? value2;
  DateTime? lastUpdate;
  DateTime? nextUpdate;


  Conversor({
    this.fromCurrency,
    this.toCurrency,
    this.value1 = 0,
    this.conversionRate,
    this.value2 = 0,
    this.lastUpdate,
    this.nextUpdate,
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

  Future<void> selectCurrency(Currency fromCurrency, Currency toCurrency) async {
    final String url = 'https://v6.exchangerate-api.com/v6/42e34072e37619ccfc32f0be/pair/${toCurrency.iso}/${fromCurrency.iso}';

    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      CurrencyConversionRequest responseObj = CurrencyConversionRequest.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      conversionRate = responseObj.conversionRate;
      this.fromCurrency = fromCurrency;
      this.toCurrency = toCurrency;
      this
        ..lastUpdate = DateTime.fromMillisecondsSinceEpoch(responseObj.timeLastUpdateUnix! * 1000)
        ..nextUpdate = DateTime.fromMillisecondsSinceEpoch(responseObj.timeNextUpdateUnix! * 1000);
    
      print('Conversion rate: $conversionRate');
    }

    // set the values

    await CurrenciesService().saveConversorData(this);
  }

  Future<void> updateFromCurrency(Currency fromCurrency) async {
    return selectCurrency(fromCurrency, toCurrency!);
  }


  Future<void> updateToCurrency(Currency toCurrency) async {
    return selectCurrency(fromCurrency!, toCurrency);
  }
  
  @override
  Conversor fromMap(Map<String, dynamic> map) => Conversor(
    fromCurrency: Currency().fromMap(map["fromCurrency"]),
    toCurrency: Currency().fromMap(map["toCurrency"]),
    value1: map["value1"],
    conversionRate: map["conversionRate"],
    value2: map["value2"],
    lastUpdate: DateTime.parse(map["lastUpdate"]),
    nextUpdate: DateTime.parse(map["nextUpdate"]),
  );
  
  @override
  Map<String, dynamic> toMap() => {
    "fromCurrency": fromCurrency!.toMap(),
    "toCurrency": toCurrency!.toMap(),
    "value1": value1,
    "conversionRate": conversionRate,
    "value2": value2,
    "lastUpdate": lastUpdate!.toIso8601String(),
    "nextUpdate": nextUpdate!.toIso8601String(),
  };
}