import 'dart:convert';
import 'package:currencii/src/models/conversor.dart';
import 'package:currencii/src/models/currency.dart';
import 'package:currencii/src/services/lib/services/local_storage.service.dart';
import 'package:flutter/services.dart' show rootBundle;

class CurrenciesService {
  final LocalStorageService _localStorageSvc = LocalStorageService();

  Future<String> readFile(String filePath) async {
    return await rootBundle.loadString(filePath);
  }

  getCurrencies() async {
    // read local json file and return currencies
    String filePath = 'assets/data/currencies.json';
    String jsonContent = await readFile(filePath);
    List<dynamic> jsonList = jsonDecode(jsonContent);
    return jsonList.map((map) => Currency().fromMap(map)).toList();
  }

  // get favorite currencies from local storage
  Future<List<String>> getFavoriteCurrencies() async {
    List<String> currencies = _localStorageSvc.getListOfStrings(LsKey.favouriteCurrencies);
    return currencies;
  }

  // save favorite currency in local storage
  saveFavoriteCurrency(Currency currency) async {
    List<String> currencies = await getFavoriteCurrencies();
    currencies.add(currency.iso);
    _localStorageSvc.saveListOfStrings(LsKey.favouriteCurrencies, currencies);
  }

  // remove favorite currency from local storage
  removeFavoriteCurrency(Currency currency) async {
    List<String> currencies = await getFavoriteCurrencies();
    currencies.remove(currency.iso);
    _localStorageSvc.saveListOfStrings(LsKey.favouriteCurrencies, currencies);
  }

  // save selected currencies
  saveConversorData(Conversor conversor) async {
    _localStorageSvc.saveObject(LsKey.conversor, conversor);
  }

  // get selected currencies
  Future<Conversor?> getConversorData() async {
    return _localStorageSvc.getObject(LsKey.conversor, Conversor());
  }
}