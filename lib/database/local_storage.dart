import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:nss_new/model/user_model.dart';

class LocalStorage {
  static final _box = GetStorage();

  static bool get isLoggedIn => _box.read("isLoggedIn") ?? false;

  writeRole(String role) {
    try {
      _box.write('role', role);
    } catch (e) {
      log(e.toString());
    }
  }

  writeUser(Users user) {
    try {
      _box.write('user', user.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  writeToken(String toc) {
    try {
      _box.write('token', toc);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> readToken() async {
    try {
      final token = await _box.read('token');
      return token;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Users readUser() {
    try {
      final data = _box.read('user');
      return Users.fromJson(data);
    } catch (e) {
      log(e.toString());
    }
    return Users();
  }

  clearAll() {
    _box.erase();
  }
}
