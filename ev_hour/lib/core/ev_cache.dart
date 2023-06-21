import 'package:shared_preferences/shared_preferences.dart';

///缓存管理类
class EvSPCache {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  EvSPCache._internal();

  static final EvSPCache _instance = EvSPCache._internal();

  factory EvSPCache() => _instance;

  setString(String key, String value) async {
    SharedPreferences sp = await _prefs;
    sp.setString(key, value);
  }

  setDouble(String key, double value) async {
    SharedPreferences sp = await _prefs;
    sp.setDouble(key, value);
  }

  setInt(String key, int value) async {
    SharedPreferences sp = await _prefs;
    sp.setInt(key, value);
  }

  setBool(String key, bool value) async {
    SharedPreferences sp = await _prefs;
    sp.setBool(key, value);
  }

  remove(String key) async {
    SharedPreferences sp = await _prefs;
    sp.remove(key);
  }

  Future<T?> get<T>(String key) async {
    SharedPreferences sp = await _prefs;
    Object? obj = sp.get(key);
    if (null == obj) {
      return null;
    }
    return obj as T;
  }
}
