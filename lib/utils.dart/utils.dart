import 'package:flutter/material.dart';

double getWidthDevice(BuildContext context, int percent) {
  return MediaQuery.of(context).size.width * (percent / 100);
}

double getHeightDevice(BuildContext context, int percent) {
  return MediaQuery.of(context).size.height * (percent / 100);
}
