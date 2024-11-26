
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:number2words/number2words.dart';

String getCurrentDate() {
  final now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
}

String getCurrentTime() {
  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;

  String period = hour >= 12 ? "PM" : "AM";

  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  String minuteStr = minute.toString().padLeft(2, '0');

  return "$hour:$minuteStr $period";
}

showMessage(context, message){
  showToast(
      message,
      context: context,
      backgroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),
      duration: const Duration(seconds: 3),
      position: StyledToastPosition.top);
}

String getConvertedText(number){
  String value = Number2Words.convert(
    number,
    language: Number2WordsLanguage.english,
    wordCase: WordCaseEnum.titleCase,
  );
  return value.replaceAll('Dollars', '');
}