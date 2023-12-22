import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage extends CognitoStorage {
  final SharedPreferences? _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    String? newKey;
    try {
      newKey = _prefs?.getString(key);
      item = json.decode(newKey!);
    } catch (e) {
      return null;
    }
    return item;
  }

  setEmail(String key, String email) async {
    await _prefs!.setString(key, email);
  }

  @override
  Future setItem(String key, value) async {
    await _prefs?.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    try {
      await _prefs?.remove(key);
      return item;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
