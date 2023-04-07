import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  checkLogin() async {
    //mengecek apakah user sudah login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userId') != null) {
      //jika sudah login langsung ke home
      Get.offAllNamed(Routes.HOME);
    } else {
      //jika belum login langsung ke login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
