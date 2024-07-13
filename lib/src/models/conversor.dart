import 'dart:convert';

import 'package:currencii/src/models/calculator.dart';
import 'package:currencii/src/models/currency.dart';
import 'package:currencii/src/models/currency_conversion_request.dart';
import 'package:currencii/src/services/currencies.service.dart';
import 'package:currencii/src/services/lib/services/local_storage.service.dart';
import 'package:currencii/src/shared/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Conversor extends LsParser<Conversor> {
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

  Future<void> selectNewCurrency(
      Currency fromCurrency, Currency toCurrency) async {
    final String url =
        'https://v6.exchangerate-api.com/v6/42e34072e37619ccfc32f0be/pair/${toCurrency.iso}/${fromCurrency.iso}';

    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      CurrencyConversionRequest responseObj =
          CurrencyConversionRequest.fromJson(
              jsonDecode(response.body) as Map<String, dynamic>);
      conversionRate = responseObj.conversionRate;
      this.fromCurrency = fromCurrency;
      this.toCurrency = toCurrency;
      this
        ..lastUpdate = DateTime.fromMillisecondsSinceEpoch(
            responseObj.timeLastUpdateUnix! * 1000)
        ..nextUpdate = DateTime.fromMillisecondsSinceEpoch(
            responseObj.timeNextUpdateUnix! * 1000);

      print('Conversion rate: $conversionRate');
    }

    // set the values

    await CurrenciesService().saveConversorData(this);
  }

  Future<void> setCurrency(Conversor conversor) async {
    if(conversor.nextUpdate == null || conversor.nextUpdate!.isBefore(DateTime.now())) {
      await selectNewCurrency(conversor.fromCurrency!, conversor.toCurrency!);
    } else {
      this
        ..fromCurrency = conversor.fromCurrency
        ..toCurrency = conversor.toCurrency
        ..conversionRate = conversor.conversionRate
        ..lastUpdate = conversor.lastUpdate
        ..nextUpdate = conversor.nextUpdate;
    }
  }

  Future<void> setDefaultCurrencyValues() {
    return selectNewCurrency(
      Currency(iso: 'EUR', name: 'Euro', flag: '🇪🇺'),
      Currency(iso: 'USD', name: 'Dollar', flag: '🇺🇸'),
    );
  }

  Future<void> updateFromCurrency(Currency newFromCurrency) async {
    if(newFromCurrency.iso == toCurrency!.iso) {
      return selectNewCurrency(newFromCurrency, fromCurrency!);
    }
    return selectNewCurrency(newFromCurrency, toCurrency!);
  }

  Future<void> updateToCurrency(Currency newToCurrency) async {
    if(newToCurrency.iso == fromCurrency!.iso) {
      return selectNewCurrency(toCurrency!, newToCurrency);
    }
    return selectNewCurrency(fromCurrency!, newToCurrency);
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
