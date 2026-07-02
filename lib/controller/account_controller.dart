import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nss_new/api.dart';
import 'package:nss_new/database/local_storage.dart';
import 'package:nss_new/model/user_model.dart';
import 'package:nss_new/view/home_screen.dart';

enum UserRole { po, sec, vol }

class AccountController {
  TextEditingController userNameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  Future<void> login() async {
    errorMessage.value = '';

    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields!';
      Get.snackbar("Error", "Please fill all fields");

      return;
    }
    isLoading.value = true;

    Api().login({'admission_number': userName, 'password': password}).then((
      response,
    ) async {
      if (response?.status == true && response?.data?.admissionNo != null) {
        await LocalStorage().writeUser(response?.data ?? Users());
        await LocalStorage().writeToken(response?.token ?? '');
        await LocalStorage().writeRole(response?.role ?? '');

        Get.snackbar(
          'Welcome',
          '${response?.data?.name}',
          icon: Icon(Icons.login, color: Colors.white),
        );
        Get.offAll(() => HomeScreen());
      } else {
        errorMessage.value = response?.message ?? 'Failed to login!';
        Get.snackbar('Error', errorMessage.value);
      }
      isLoading.value = false;
    });
  }
}
