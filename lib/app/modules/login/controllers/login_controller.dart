import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:blindcolor_test/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final isAdmin = false.obs;
  final isDaftar = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  final db = FirebaseFirestore.instance;

  void toggleAdmin() {
    isAdmin.value = !isAdmin.value;
    if (isAdmin.value == true) {
      isDaftar.value = false;
    }
  }

  void toggleDaftar() {
    isDaftar.value = !isDaftar.value;
  }

  bool isValidEmail(String value) {
    // Define a regex pattern to validate email addresses
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    // Check if the entered value matches the expected email format
    if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  clearText() {
    //mengosongkan textfield
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
  }

  void login() async {
    late List<DocumentSnapshot> documents;
    //cek username dan password in firestore
    final QuerySnapshot result = await db
        .collection('users')
        .where('username', isEqualTo: usernameController.text)
        .where('password', isEqualTo: passwordController.text)
        .get() as QuerySnapshot;
    documents = result.docs;

    //cek jika ada data
    if (documents.length == 1) {
      //simpan data ke shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', documents[0].id);
      prefs.setString('username', documents[0]['username']);
      prefs.setString('nama', documents[0]['nama']);
      prefs.setBool('isAdmin', isAdmin.value);

      clearText();
      Get.back();
      Get.snackbar(
        'Login',
        'Berhasil Login',
        colorText: Colors.white,
        backgroundColor: kPrussianBlue,
      );
      Get.offAndToNamed(Routes.HOME);
    } else {
      Get.back();
      Get.snackbar('Login', 'Username atau Password salah',
          colorText: Colors.white, backgroundColor: kRed);
    }
  }

  void daftar() async {
    //cek username in firestore
    final QuerySnapshot result = await db
        .collection('users')
        .where('username', isEqualTo: usernameController.text)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      //jika username sudah ada
      Get.back();
      Get.snackbar(
        'Daftar',
        'Username sudah terdaftar',
        colorText: Colors.white,
        backgroundColor: kRed,
      );
      return;
    }

    //jika username belum ada menambahkan data ke firestore
    await db.collection('users').add({
      'nama': namaController.text,
      'username': usernameController.text,
      'password': passwordController.text,
    });
    clearText();
    Get.back();
    Get.snackbar(
      'Daftar',
      'Berhasil Daftar',
      colorText: Colors.white,
      backgroundColor: kPrussianBlue,
    );
  }
}
