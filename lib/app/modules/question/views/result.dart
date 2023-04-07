import 'package:blindcolor_test/app/modules/question/controllers/question_controller.dart';
import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:blindcolor_test/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    //untuk mengatur tombol back
    Future<bool> _onWillPop() async {
      Get.offAllNamed(Routes.HOME);
      return false;
    }

    //mengambil controller
    final controller = Get.find<QuestionController>();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            //mengecek apakah data sudah ada atau belum
            if (snapshot.hasData) {
              final data = snapshot.data as Map<String, dynamic>;
              final int correct = data['correct'];
              var status = "";
              if (correct >= 17) {
                status = "Tidak Buta Warna";
              } else if (correct >= 13) {
                status = "Buta Warna Red Green";
              } else {
                status = "Buta Warna";
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Anda dinyatakan \n${status}",
                    style: const TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.HOME);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(kPrussianBlue),
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            elevation: MaterialStateProperty.all<double>(2),
                          ),
                          child: const Text('Kembali ke Beranda'),
                        ),
                      ),
                      SizedBox(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.downloadPDF(data['docId']);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrussianBlue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text('Download PDF'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: controller.calculateResult(),
        ),
      )),
    );
  }
}
