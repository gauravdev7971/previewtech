
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget{
  final String text;
  final Function buttonAction;
  Color? buttonColor;

  ButtonPrimary({required this.text, required this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        buttonAction();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.shade400,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),)],),
      ),
    );
  }

}