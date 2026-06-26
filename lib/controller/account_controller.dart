import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nss_new/view/home_screen.dart';

enum UserRole { programOfficer, secretary, volunteer }

class AccountController {
  final admnNoController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  final box = GetStorage();

  Future<void> login() async {
    final admnNo = admnNoController.text.trim().toUpperCase();
    final password = passwordController.text.trim();

    if (admnNo.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));
    final mockUsers = {
      "PO001": {"password": "123456", "role": UserRole.programOfficer.name},
      "SEC001": {"password": "123456", "role": UserRole.secretary.name},
      "VOL001": {"password": "123456", "role": UserRole.volunteer.name},
    };

    final user = mockUsers[admnNo];

    if (user != null && user["password"] == password) {
      // Save login info
      box.write("isLoggedIn", true);
      box.write("role", user["role"]);
      box.write("admissionNo", admnNo);

      Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar("Login Failed", "Invalid Admission Number or Password");
    }

    isLoading.value = false;
  }
}
