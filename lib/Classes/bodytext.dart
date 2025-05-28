import 'package:flutter/material.dart';


double textSizeMulti = 1;  
const int defaultBodyTextSize = 16;

Text bodyText({required String text, int fontSize = defaultBodyTextSize, Color color = Colors.black, String fontFamily = "robotoSlab"}) {
  return Text(text, style: TextStyle(fontSize: fontSize * textSizeMulti, color: color, fontFamily: fontFamily),);
}

void setTextSize(double size) {
  textSizeMulti = size;
}

double getTextSize() {
  return textSizeMulti;
}
