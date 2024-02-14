import 'package:flutter/material.dart';

extension BuildContextExtention on BuildContext {
  double getWidthDevice(int percent) {
    return MediaQuery.of(this).size.width * (percent / 100);
  }

  double getHeightDevice(int percent) {
    return MediaQuery.of(this).size.height * (percent / 100);
  }
}
