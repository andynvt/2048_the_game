import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static CacheService _sInstance;
  SharedPreferences _service;

  CacheService._();

  factory CacheService.shared() {
    if (_sInstance == null) {
      _sInstance = CacheService._();
    }
    return _sInstance;
  }

  static Future init() async {
    return await CacheService.shared()._init();
  }

  Future _init() async {
    _service = await SharedPreferences.getInstance();
  }

  T _get<T>(String key) {
    final v = _service.get(key);
    if (v is T) return v;
    return null;
  }

  bool getBool(String key, {bool defValue = false}) {
    return _get<bool>(key) ?? defValue;
  }

  int getInt(String key, {int defValue = 0}) {
    return _get<int>(key) ?? defValue;
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _get<double>(key) ?? defValue;
  }

  String getString(String key, {String defValue = ""}) {
    return _get<String>(key) ?? defValue;
  }

  List<String> getListString(String key, {List<String> defValue}) {
    List<String> ls = _get<List<String>>(key);
    if (ls == null) {
      return defValue ?? [];
    }
    return ls;
  }

  bool hasKey(String key) {
    return _service.containsKey(key);
  }

  void setBool(String key, bool value) {
    _service.setBool(key, value);
  }

  void setInt(String key, int value) {
    _service.setInt(key, value);
  }

  void setDouble(String key, double value) {
    _service.setDouble(key, value);
  }

  Future<bool> setString(String key, String value) {
    return _service.setString(key, value);
  }

  Future<bool> setListString(String key, List<String> value) {
    return _service.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    return _service.remove(key);
  }

  Future<bool> clear() {
    return _service.clear();
  }

  Future<void> reload() {
    return _service.reload();
  }

  void removePrefix(String prefix) {
    _service.getKeys().forEach((key) {
      if (key.startsWith(prefix)) {
        _service.remove(key);
      }
    });
  }
}
