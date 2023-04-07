import 'dart:async';
import 'dart:io';

import 'package:blindcolor_test/app/modules/question/views/result.dart';
import 'package:blindcolor_test/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:blindcolor_test/app/data/plates.dart';

class QuestionController extends GetxController {
  final questions = [].obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var loading = false.obs;
  // List imageUrl = [].obs;
  Timer? _timer;
  RxString time = '6'.obs;
  int durationInSeconds = 6;
  RxInt questionIndex = 0.obs;
  List answers = [].obs;
  TextEditingController answerController = TextEditingController();

  @override
  void onInit() {
    Future.delayed(Duration.zero, () {
      loading.value = true;
      getQuestions();
    });
    super.onInit();
  }

  getQuestions() async {
    answers.clear();
    try {
      loading.value = true;
      // var index0 = {};
      // var questTemp = [];
      // await firestore
      //     .collection('plates')
      //     .orderBy('tanggal', descending: false)
      //     .get()
      //     .then((value) {
      //   var i = 0;
      //   for (var element in value.docs) {
      //     if (i > 0) {
      //       questTemp.add({
      //         'image': element.data()['image'],
      //         'answer': element.data()['answer'],
      //         'id': element.id
      //       });
      //     } else {
      //       index0 = {
      //         'image': element.data()['image'],
      //         'answer': element.data()['answer'],
      //         'id': element.id
      //       };
      //     }
      //     i++;
      //   }
      // });
      // questTemp.shuffle();
      // questTemp.insert(0, index0);
      // questions.value = questTemp;
      var questTemp = [];
      questTemp.addAll(randomPlates);
      questTemp.shuffle();
      questTemp.insert(0, firstPlates);
      questions.value = questTemp;

      loading.value = false;
      startTimer();
    } catch (e) {
      //show dialog error and back to home
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Something went wrong ${e}'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.offAllNamed(Routes.HOME);
              },
              child: Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  void startTimer() {
    answerController.clear();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (durationInSeconds > 0) {
        durationInSeconds--;
        time.value = _formatDuration(Duration(seconds: durationInSeconds));
      } else {
        _timer?.cancel();
        _nextQuestion();
      }
    });
    // print(time);
  }

  void _nextQuestion() {
    if (questionIndex.value < questions.length - 1) {
      saveAnswer();
      questionIndex.value++;
      durationInSeconds = 6;
      time.value = _formatDuration(Duration(seconds: durationInSeconds));
      startTimer();
    } else {
      // end of quiz
      // print('next 1');
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) {
        return const Result();
      }));
    }
  }

  void skipWaiting() async {
    await saveAnswer();
    next();
  }

  saveNothing() {
    answers.add({
      'id': questions[questionIndex.value]['id'],
      'answer': "Nothing",
      'corectAnswer': questions[questionIndex.value]['answer'],
    });
    next();
  }

  next() {
    if (questionIndex.value == questions.length - 1) {
      // end of quiz
      print('next 2');
      _timer?.cancel();
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) {
        return const Result();
      }));
    } else {
      questionIndex++;
      time.value = "6";
      durationInSeconds = 6;
      answerController.clear();
    }
  }

  saveAnswer() {
    var jawaban = {
      'id': questions[questionIndex.value]['id'],
      'answer': answerController.text.toString(),
      'corectAnswer': questions[questionIndex.value]['answer'].toString(),
    };
    answers.add(jawaban);
  }

  String _formatDuration(Duration duration) {
    return duration.inSeconds.toString().padLeft(2, '0');
  }

  calculateResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int correct = 0;
    int wrong = 0;
    for (var element in answers) {
      if (element['answer'] == element['corectAnswer']) {
        //correct
        correct++;
      } else {
        //wrong
        wrong++;
      }
      // print(
      //     "${element['answer']} - ${element['corectAnswer']} = ${element['answer'] == element['corectAnswer']} \n");
    }

    //insert to firestore and get document id
    var docId = await firestore.collection('results').add({
      'correct': correct,
      'wrong': wrong,
      'total': answers.length,
      'user': prefs.getString('userId'),
      'date': DateTime.now(),
    });

    var result = {
      'correct': correct,
      'wrong': wrong,
      'total': answers.length,
      'docId': docId.id
    };

    return result;
  }

  downloadPDF(docId) async {
    DocumentSnapshot data =
        await firestore.collection('results').doc(docId).get();
    Map<String, dynamic> result = data.data() as Map<String, dynamic>;
    DocumentSnapshot user =
        await firestore.collection('users').doc(result['user']).get();
    Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
    // print(result);
    // print(userData);
    var date = result['date'].toDate();
    var formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(date);
    var status = "";
    if (result['correct'] >= 17) {
      status = "Tidak Buta Warna";
    } else if (result['correct'] >= 13) {
      status = "Buta Warna Red Green";
    } else {
      status = "Buta Warna ";
    }
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      'Hasil Tes Buta Warna',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  // pw.Row(
                  //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //   children: [
                  //   ],
                  // ),
                  pw.Text('Nama : ${userData['nama']}'),
                  pw.SizedBox(height: 10),
                  pw.Text('Tanggal : ${formatted}'),
                  pw.SizedBox(height: 10),
                  pw.Text('Anda dinyatakan ${status}'),
                ]),
          );
        },
      ),
    );

    Uint8List bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/hasil.pdf');

    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
