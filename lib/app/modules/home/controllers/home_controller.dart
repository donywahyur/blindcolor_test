import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  // void createPlates() async {
  //   var jawabanPlate = {
  //     'plate1': 12,
  //     'plate2': 8,
  //     'plate3': 6,
  //     'plate4': 29,
  //     'plate5': 57,
  //     'plate6': 5,
  //     'plate7': 3,
  //     'plate8': 15,
  //     'plate9': 74,
  //     'plate10': 2,
  //     'plate11': 6,
  //     'plate12': 97,
  //     'plate13': 45,
  //     'plate14': 5,
  //     'plate15': 7,
  //     'plate16': 16,
  //     'plate17': 73,
  //     'plate18': "Nothing",
  //     'plate19': "Nothing",
  //     'plate20': "Nothing",
  //     'plate21': "Nothing",
  //     'plate22': 26,
  //     'plate23': 42,
  //     'plate24': 35,
  //     'plate25': 96,
  //   };
  //   await FirebaseStorage.instance
  //       .ref()
  //       .child('plates')
  //       .listAll()
  //       .then((result) async {
  //     for (var element in result.items) {
  //       final url = await element.getDownloadURL();
  //       //insert to firestore plates
  //       await FirebaseFirestore.instance.collection('plates').doc().set({
  //         'image': url,
  //         'answer': jawabanPlate[element.name.split('.')[0]],
  //         'tanggal': DateTime.now()
  //       });
  //     }
  //   });
  // }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    Get.offAllNamed(Routes.LOGIN);
  }
}
