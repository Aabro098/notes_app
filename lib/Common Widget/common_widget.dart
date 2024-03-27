import 'dart:math';
import 'package:flutter/material.dart';
import '../App Styles/color_style.dart';

Color getRandomColor() {
  Random random = Random();
  int randomIndex = random.nextInt(ColorStyle.cardsColor.length);
  return ColorStyle.cardsColor[randomIndex];
}
