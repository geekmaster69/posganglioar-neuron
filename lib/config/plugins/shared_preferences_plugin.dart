import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPlugin {
  Future<SharedPreferences> _loadPref() {
    return SharedPreferences.getInstance();
  }

  Future<T?> getValue<T>(String key) async {
    final pref = await _loadPref();

    switch (T) {
      case const (int):
        return pref.getInt(key) as T?;

      case const (String):
        return pref.getString(key) as T?;

      default:
        throw UnimplementedError(
          'No esta implementeado para un ${T.runtimeType}',
        );
    }
  }

  Future<bool> removeKey(String key) async {
    final pref = await _loadPref();
    return await pref.remove(key);
  }

  Future<void> setValue<T>(String key, T value) async {
    final pref = await _loadPref();
    switch (T) {
      case const (int):
        pref.setInt(key, value as int);
        break;

      case const (String):
        pref.setString(key, value as String);
        break;

      default:
        throw UnimplementedError(
          'No esta implementeado para un ${T.runtimeType}',
        );
    }
  }
}
