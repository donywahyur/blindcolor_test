import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //delay 1 detik untuk cek login
    Future.delayed(const Duration(seconds: 1), () {
      controller.checkLogin();
    });
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/LogoPolinema.png'),
          const SizedBox(height: 16),
          CircularProgressIndicator()
        ],
      )),
    );
  }
}
