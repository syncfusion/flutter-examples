import 'package:flutter/material.dart';

import '../data_processing/windows_path_file.dart'
    if (dart.library.html) '../data_processing/web_path_file.dart';
import '../helper/common_helper.dart';
import '../helper/predefined_data.dart';
// import '../models/budget.dart';
// import '../models/goal.dart';
// import '../models/saving.dart';
// import '../models/transaction.dart';
import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
// import '../models/user_profile.dart';

class ImportNotifier extends ChangeNotifier {
  UserDetails? _user;
  UserDetails? get user => _user;

  bool _isFileAdded = false;
  bool get isFileAdded => _isFileAdded;

  Profile? _userProfile;

  bool _isFileDownloaded = true;
  bool get isFileDownloaded => _isFileDownloaded;

  String _fileName = 'Expense Tracker Data.xlsx';
  String get fileName => _fileName;

  final String _downloadedFileName = 'Sample Data';
  String get downloadedFileName => _downloadedFileName;

  String _fileSize = '';
  String get fileSize => _fileSize;

  Future<void> updateUserDetails(UserDetails userDetails) async {
    _user = userDetails;
    if (_userProfile != null) {
      _user?.userProfile = _userProfile!;
    }
    notifyListeners();
  }

  void updateUserProfile(Profile profile) {
    _userProfile = profile;
    _user?.userProfile = profile;
  }

  void resetAppData(Profile profile) {
    _userProfile = profile;
    _user = _defaultUserDetails(profile);
  }

  UserDetails _defaultUserDetails(Profile profile) {
    return UserDetails(
      userProfile: profile,
      transactionalData: TransactionalData(
        data: TransactionalDetails(
          transactions: [],
          budgets: [],
          goals: [],
          savings: [],
        ),
      ),
    );
  }

  void validateDownloadFile({bool isDownloaded = false}) {
    _isFileDownloaded = isDownloaded;
    notifyListeners();
  }

  void validateFinishButton({
    required int fileSizeInKb,
    required String fileName,
    bool enable = false,
  }) {
    _isFileDownloaded = false;
    _isFileAdded = enable;
    _fileName = fileName;
    _fileSize = '$fileSizeInKb KB';
    notifyListeners();
  }

  Future<void> updateDetails(BuildContext context, bool isSkip) async {
    final UserDetails userDetails = await readUserDetailsFromFile();
    _user = userDetails;
    if (_userProfile != null) {
      _user?.userProfile = _userProfile!;
    }
    if (isSkip) {
      _user = setDefaultUserDetails(_user!.userProfile);
    }
    notifyListeners();
  }

  Future<void> updateDefaultTemplateDetails(BuildContext context) async {
    final UserDetails userDetails = await readUserDetailsFromFile();
    userDetails.transactionalData = TransactionalData(
      data: _defaultTransactionalDetails(userDetails),
    );
    // await writeUserDetailsToFile(userDetails);
    _user = userDetails;
    notifyListeners();
  }

  TransactionalDetails _defaultTransactionalDetails(UserDetails user) {
    return TransactionalDetails(
      transactions: predefinedTransactions,
      budgets: predefinedBudgets,
      goals: predefinedGoals,
      savings: predefinedSavings,
    );
  }
}

Future<ImportNotifier> initializeImportNotifier() async {
  // Simulate some asynchronous task
  await Future<ImportNotifier>.delayed(const Duration(seconds: 20));
  return ImportNotifier();
}
