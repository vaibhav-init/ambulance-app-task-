import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

getAnimation() {
  return Lottie.network(
    'https://assets4.lottiefiles.com/packages/lf20_usmfx6bp.json',
    height: 150,
    width: 150,
  );
}
