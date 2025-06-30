import 'package:flutter/material.dart';
// import '../data_processing/utils.dart';
import '../helper/responsive_layout.dart';
import '../models/user_profile.dart';

class DrawerNotifier extends ChangeNotifier {
  bool _isDrawerExpanded = true;
  bool get isExpanded => _isDrawerExpanded;

  void toggleDrawer(BuildContext context, Profile profile) {
    if (!isTablet(context)) {
      profile.isDrawerExpanded = !profile.isDrawerExpanded;
    } else {
      profile.isDrawerExpanded = false;
    }
    _isDrawerExpanded = profile.isDrawerExpanded;
    // updateUserProfile(context, profile);
    notifyListeners();
  }
}
