import 'package:flutter/material.dart';

abstract class ETNotifier extends ChangeNotifier {
  void create();
  void edit();
  void remove();
  void dateRangeFilter();
  void segmentFilter();
}
