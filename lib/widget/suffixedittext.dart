// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:yourappname/utils/color.dart';
import 'package:yourappname/widget/myimage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SuffixEdittext extends StatelessWidget {
  late String hinttext;
  double size;
  late Color textcolor, hintcolor;
  var textInputAction, controller, keyboardType, prefixicon, suffixtext;
  bool obscureText;

  SuffixEdittext(
      {Key? key,
      required this.hintcolor,
      required this.hinttext,
      required this.keyboardType,
      required this.controller,
      required this.size,
      required this.textcolor,
      this.prefixicon,
      this.suffixtext,
      required this.textInputAction,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      controller: controller,
      textInputAction: textInputAction,
      cursorColor: white,
      style: GoogleFonts.montserrat(
          fontSize: size,
          fontStyle: FontStyle.normal,
          color: textcolor,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: white),
        ),
        enabledBorder:
            const UnderlineInputBorder(borderSide: BorderSide(color: black)),
        prefixIcon: prefixicon != null
            ? Container(
                width: 5,
                height: 5,
                alignment: Alignment.center,
                child:
                    MyImage(width: 25, height: 25, imagePath: prefixicon ?? ""))
            : Container(),
        suffixText: suffixtext,
        hintText: hinttext,
        hintStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: hintcolor,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
