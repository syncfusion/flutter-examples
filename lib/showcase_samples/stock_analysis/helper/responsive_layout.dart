import 'package:flutter/material.dart';

import '../enum.dart';

DeviceType deviceType(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth >= 1050) {
    return DeviceType.desktop;
  } else {
    return DeviceType.mobile;
  }
}
