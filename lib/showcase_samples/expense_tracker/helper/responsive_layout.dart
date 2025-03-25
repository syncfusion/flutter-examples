import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600.0;
}

bool isTablet(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth >= 600.0 && screenWidth < 1050.0;
}

enum DeviceType { desktop, mobile, tablet }

DeviceType deviceType(Size size) {
  if (size.width >= 850) {
    return DeviceType.desktop;
  } else if (size.width >= 600) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}
