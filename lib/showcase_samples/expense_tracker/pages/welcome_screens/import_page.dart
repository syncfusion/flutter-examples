// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../meta_tag/meta_tag.dart';
import '../../base.dart';
import '../../constants.dart';
// import '../../data_processing/utils.dart';
import '../../data_processing/windows_path_file.dart'
    if (dart.library.html) '../../data_processing/web_path_file.dart';
import '../../helper/responsive_layout.dart';
// import '../../import_export/import.dart';
import '../../models/user.dart';
import '../../notifiers/import_notifier.dart';
import '../../notifiers/setup_notifier.dart';
import '../base_home.dart';

class ImportPage extends StatefulWidget {
  const ImportPage(this.userDetails, this.pageController, {super.key});

  final PageController pageController;

  final UserDetails userDetails;

  @override
  ImportPageState createState() => ImportPageState();
}

class ImportPageState extends State<ImportPage> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;

  VerifyUserNotifier? _homeScreenNotifier;
  ImportNotifier? _importNotifier;
  final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: SingleChildScrollView(child: _buildImportPage(context)),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 2,
          child: Image.asset('assets/screen_cover.png', fit: BoxFit.fill),
        ),
        Expanded(
          child: ColoredBox(
            color: _colorScheme.surface,
            child: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildImportPage(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImportPage(BuildContext context) {
    return Consumer<ImportNotifier>(
      builder: (BuildContext context, ImportNotifier import, Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildHeader(),
            verticalSpacer12,
            _buildObjective(),
            _buildActions(import),
            verticalSpacer12,
            _buildFinishButton(context, import),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Text(
        'Import',
        textAlign: TextAlign.center,
        style: _textTheme.titleLarge!.copyWith(color: _colorScheme.onSurface),
      ),
    );
  }

  Widget _buildObjective() {
    return Text(
      r'To begin using the app, you can start with sample data or opt out.'
      r' We have also provided the option to reset '
      r'or overwrite the data at any time.',
      style: _textTheme.bodyLarge!.copyWith(
        color: _colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildImportTemplateButton(
    BuildContext context,
    ImportNotifier import,
  ) {
    return SizedBox(
      height: 60,
      child: OutlinedButton(
        onPressed: () async {
          import.validateDownloadFile(isDownloaded: true);
          await import.updateDefaultTemplateDetails(context);
          _homeScreenNotifier?.setNewUser();
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: _colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          'Continue with sample data',
          style: _textTheme.bodyLarge!.copyWith(
            color: _colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // Widget _buildUploadButton(BuildContext context, ImportNotifier import) {
  //   return OutlinedButton(
  //     onPressed: () async {
  //       // _importFile(import);
  //     },
  //     style: OutlinedButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       side: BorderSide(color: _colorScheme.outline),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  //     ),
  //     child: Text(
  //       'Upload your file',
  //       style: _textTheme.bodyLarge!.copyWith(
  //         color: _colorScheme.onSurfaceVariant,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActions(ImportNotifier import) {
    Widget result;
    if (import.isFileAdded || import.isFileDownloaded) {
      result = _buildUploadedFileDetails(import);
    } else {
      // result = Column(
      //   spacing: 12,
      //   children: [
      //     SizedBox(
      //       width: MediaQuery.of(context).size.width,
      //       child: _buildImportTemplateButton(context, import),
      //     ),
      //     // Text(
      //     //   'or',
      //     //   style: _textTheme.bodyLarge!.copyWith(
      //     //     color: _colorScheme.onSurfaceVariant,
      //     //     fontWeight: FontWeight.w400,
      //     //   ),
      //     // ),
      //     // SizedBox(
      //     //   width: MediaQuery.of(context).size.width,
      //     //   child: _buildUploadButton(context, import),
      //     // ),
      //   ],
      // );
      result = SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _buildImportTemplateButton(context, import),
      );
    }

    return SizedBox(
      height: isMobile(context) ? 150 : 120,
      child: Center(child: result),
    );
  }

  Widget _buildUploadedFileDetails(ImportNotifier import) {
    final String fileName = import.isFileAdded
        ? import.fileName
        : import.downloadedFileName;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        height: 60,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                fileName,
                style: _textTheme.bodyMedium!.copyWith(
                  color: _colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await _deleteFile();
                import.validateFinishButton(fileSizeInKb: 0, fileName: '');
              },
              icon: const Icon(Icons.delete),
            ),
            horizontalSpacer8,
            const Icon(Icons.check, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteFile() async {
    if (kIsWeb) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.clear();
    } else {
      final UserDetails userDetails = await readUserDetailsFromFile();
      widget.userDetails.userProfile = userDetails.userProfile;
      // final String filePath = await getFilePath();
      // final File file = File(filePath);
      // await file.delete();
      // await writeNewUserDetailsToFile(widget.userDetails);
    }
  }

  // void _importFile(ImportNotifier import) {
  //   try {
  //     final ExcelImporter importer = ExcelImporter(
  //       userProfile: widget.userDetails.userProfile,
  //       context: context,
  //     );
  //     importer.importSettingsFromExcel(import);
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Import failed with $e'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  // Widget _buildHelperText() {
  //   return Row(
  //     children: <Widget>[
  //       Text('Supported Format:', style: _textTheme.bodySmall),
  //       const SizedBox(width: 4),
  //       Text(
  //         '.xlsx',
  //         style: _textTheme.bodySmall!.copyWith(color: _colorScheme.primary),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildNotes() {
  //   return Row(
  //     children: [
  //       Flexible(
  //         child: Text(
  //           'Note: This is a one-time setup and cannot be changed later.',
  //           style: _textTheme.bodySmall!.copyWith(color: _colorScheme.error),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFinishButton(BuildContext context, ImportNotifier import) {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () async {
          final FirstTimeUserDetails newUserDetails =
              await isVerifyFirstTimeUser();
          if (context.mounted) {
            _importNotifier?.updateDetails(
              context,
              !(import.isFileAdded || import.isFileDownloaded),
            );
          }
          _homeScreenNotifier?.setNewUser();
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return Consumer<ImportNotifier>(
                    builder:
                        (
                          BuildContext context,
                          ImportNotifier value,
                          Widget? child,
                        ) {
                          return ExpenseAnalysis(
                            currentUserDetails: newUserDetails.userDetails,
                          );
                        },
                  );
                },
              ),
            );
          }
        },
        child: Text(
          import.isFileAdded || import.isFileDownloaded
              ? 'Finish'
              : 'Skip & Finish',
        ),
      ),
    );
  }

  @override
  void initState() {
    _homeScreenNotifier = Provider.of<VerifyUserNotifier>(
      context,
      listen: false,
    );
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _homeScreenNotifier = Provider.of<VerifyUserNotifier>(
      context,
      listen: false,
    );
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);

    // Updates meta tag details when navigating from the setup page to the
    // import page in Expense Tracker.
    metaTagUpdate.update('Import', 'Expense Tracker');

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _textTheme = themeData.textTheme;
    _colorScheme = themeData.colorScheme;

    return MediaQuery.of(context).size.width < 600
        ? _buildMobileLayout(context)
        : _buildDesktopLayout(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
