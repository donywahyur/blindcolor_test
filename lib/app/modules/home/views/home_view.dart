import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:blindcolor_test/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.createPlates();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tes Buta Warna',
            style: TextStyle(
                fontSize: 32,
                color: kPrussianBlue,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          //elevated button to start the test
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.QUESTION);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(kPrussianBlue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text('Mulai Tes'),
          ),
        ],
      )),
    );
  }
}
