import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _ls;

  static Future<void> init() async {
    _ls = await SharedPreferences.getInstance();
  }

  void saveObject<T>(LsKey key, LsParser<T> obj) {
    _ls.setString(key.name, obj.toJson());
  }

  T? getObject<T>(LsKey key, LsParser<T> obj) {
    String? json = _ls.getString(key.name);
    if (json == null) {
      return null;
    }
    return obj.fromJson(json);
  }

  void saveListOfObjects(LsKey key, List<LsParser> list) {
    _ls.setStringList(
        key.name, list.map((LsParser obj) => obj.toJson()).toList());
  }

  List<T> getListOfObjects<T>(LsKey key, LsParser<T> obj) {
    List<String>? list = _ls.getStringList(key.name);
    if (list == null) {
      return [];
    }
    return list.map((String json) => obj.fromJson(json)).toList();
  }

  void saveListOfStrings(LsKey key, List<String> list) {
    _ls.setStringList(key.name, list);
  }

  List<String> getListOfStrings(LsKey key) {
    List<String>? list = _ls.getStringList(key.name);
    if (list == null) {
      return [];
    }
    return list;
  }

  bool? getBool(LsKey key) {
    return _ls.getBool(key.name);
  }

  void saveBool(LsKey key, bool value) {
    _ls.setBool(key.name, value);
  }
}

abstract class LsParser<T> {
  Map<String, dynamic> toMap();
  T fromMap(Map<String, dynamic> map);
  String toJson() => json.encode(toMap());
  T fromJson(String json) => fromMap(jsonDecode(json));
}

enum LsKey { favouriteCurrencies, selectedCurrencies, conversor }