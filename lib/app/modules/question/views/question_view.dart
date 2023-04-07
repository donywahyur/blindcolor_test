import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:blindcolor_test/constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/question_controller.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class QuestionView extends GetView<QuestionController> {
  const QuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //mengambil lebar layar
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        //untuk menghilangkan overflow
        resizeToAvoidBottomInset: false,
        //obx untuk mengambil data dari controller
        body: Obx(() {
          //mengecek jumlah pertanyaan apakah 0 atau tidak
          return controller.questions.length == 0
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Harap tunggu menampilkan pertanyaan",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    CircularProgressIndicator(),
                  ],
                ))
              : SafeArea(
                  child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //menampilkan nomor pertanyaan
                            Text(
                                "Pertanyaan ${controller.questionIndex.toInt() + 1} / ${controller.questions.length} ",
                                style: const TextStyle(fontSize: 30)),
                            const SizedBox(height: 16),
                            //menampilkan waktu
                            LinearProgressIndicator(
                              minHeight: 20,
                              value: int.parse(controller.time.toString()) / 6,
                              backgroundColor: Colors.grey,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrussianBlue),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            //menampilkan image
                            Image.asset(
                              "${controller.questions[controller.questionIndex.toInt()]['image']}",
                              height: 400,
                              width: 400,
                            ),
                            const SizedBox(height: 16),
                            // Image.network(
                            //   "${controller.questions[controller.questionIndex.toInt()]['image']}",
                            //   height: width * 0.8,
                            //   width: width * 0.8,
                            // ),
                            // const SizedBox(height: 16),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Container(
                            //       width: width * 0.6,
                            //       height: 60,
                            //       child: TextFormField(
                            //         onSaved: (value) {
                            //           controller.answerController.text = value!;
                            //         },
                            //         controller: controller.answerController,
                            //         decoration: const InputDecoration(
                            //           hintText: "Jawaban",
                            //           border: OutlineInputBorder(),
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       width: width * 0.3,
                            //       height: 60,
                            //       child: ElevatedButton(
                            //         onPressed: () {
                            //           controller.saveNothing();
                            //         },
                            //         style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   kPrussianBlue),
                            //           foregroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   Colors.white),
                            //         ),
                            //         child: const Text('Nothing',
                            //             style: TextStyle(
                            //                 fontSize: 16,
                            //                 color: Colors.white,
                            //                 fontWeight: FontWeight.bold)),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            //menampilkan jawaban
                            Container(
                              width: width,
                              height: 60,
                              child: TextFormField(
                                onSaved: (value) {
                                  controller.answerController.text = value!;
                                },
                                controller: controller.answerController,
                                decoration: const InputDecoration(
                                  hintText: "Jawaban",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            //menampilkan button selanjutnya
                            Container(
                              width: width,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.skipWaiting();
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kPrussianBlue),
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(color: kPrussianBlue))),
                                child: const Text('Selanjutnya',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kPrussianBlue,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
        }));
  }
}
