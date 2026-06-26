import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final _box = GetStorage();

  static bool get isLoggedIn => _box.read("isLoggedIn") ?? false;

  static String get role => _box.read("role") ?? "";

  static String get admissionNo => _box.read("admissionNo") ?? "";

  static Future<void> logout() async {
    await _box.erase();
  }
}
