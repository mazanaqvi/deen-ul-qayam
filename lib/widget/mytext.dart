import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String text;
  double? fontsizeNormal, fontsizeWeb;
  // ignore: prefer_typing_uninitialized_variables
  var maxline, fontstyle, fontwaight, textalign;
  Color color;
  // ignore: prefer_typing_uninitialized_variables
  var overflow, multilanguage;

  MyText({
    Key? key,
    required this.color,
    required this.text,
    this.fontsizeNormal,
    this.maxline,
    this.overflow,
    this.fontsizeWeb,
    this.textalign,
    this.fontwaight,
    this.fontstyle,
    this.multilanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (multilanguage == true) {
      return LocaleText(
        text,
        textAlign: textalign,
        overflow: overflow,
        maxLines: maxline,
        style: kIsWeb
            ? TextStyle(
                fontSize: (kIsWeb) ? fontsizeWeb : fontsizeNormal,
                fontStyle: fontstyle,
                color: color,
                fontWeight: fontwaight)
            : GoogleFonts.inter(
                fontSize: (kIsWeb) ? fontsizeWeb : fontsizeNormal,
                fontStyle: fontstyle,
                color: color,
                fontWeight: fontwaight),
      );
    } else {
      return Text(
        text,
        textAlign: textalign,
        overflow: overflow,
        maxLines: maxline,
        style: kIsWeb
            ? TextStyle(
                fontSize: (kIsWeb) ? fontsizeWeb : fontsizeNormal,
                fontStyle: fontstyle,
                color: color,
                fontWeight: fontwaight)
            : GoogleFonts.inter(
                fontSize: (kIsWeb) ? fontsizeWeb : fontsizeNormal,
                fontStyle: fontstyle,
                color: color,
                fontWeight: fontwaight),
      );
    }
  }
}
