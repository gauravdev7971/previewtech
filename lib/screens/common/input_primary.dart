
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:previewtech/utils/ccolor.dart';
import 'package:google_fonts/google_fonts.dart';

class InputPrimary extends StatelessWidget{
  final TextEditingController controller;
  final String hintText, labelText, suffixText;
  final TextInputType inputType;
  final int maxLength;
  Function clearAction;

  InputPrimary({required this.suffixText, required this.hintText, required this.labelText, required this.controller, required this.inputType, required this.maxLength, required this.clearAction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      style: GoogleFonts.montserrat(color: Colors.white),
      decoration: InputDecoration(
        fillColor: primaryTeal,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorBlueLight, width: 0.6),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0, ),
        focusedBorder: const OutlineInputBorder(),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        suffix: Visibility(
          visible: controller.text.isNotEmpty,
          child: InkWell(onTap: (){
            clearAction();
          }, child: const Icon(CupertinoIcons.clear_circled_solid, color: Colors.white, size: 18.0,)),
        )
      ),
    );
  }

}