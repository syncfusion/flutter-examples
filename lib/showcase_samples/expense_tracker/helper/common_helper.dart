import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
// import '../import_export/export.dart';
import '../models/transactional_data.dart';
import '../models/transactional_details.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../notifiers/theme_notifier.dart';

Widget buildNoRecordsFound(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            'No Records Found',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: themeData.textTheme.bodySmall!.copyWith(
              color: themeData.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}

double measureTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.size.width;
}

List<Color> randomColors(BuildContext context) {
  final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(
    context,
    listen: false,
  );
  final Random random = Random.secure();
  final List<Color> cardAvatarColors = _cardAvatarColors(themeNotifier);

  return List.generate(10, (int index) {
    return _randomColor(cardAvatarColors, random);
  });
}

List<Color> _cardAvatarColors(ThemeNotifier themeNotifier) {
  return themeNotifier.isDarkTheme ? Colors.primaries : _darkPrimaries();
}

Color _randomColor(List<Color> colors, Random random) {
  return colors[random.nextInt(colors.length)];
}

List<MaterialColor> _darkPrimaries() {
  const double luminanceThreshold = 0.7;
  return Colors.primaries.where((Color color) {
    return color.computeLuminance() < luminanceThreshold;
  }).toList();
}

class SelectedCountsTag extends StatelessWidget {
  const SelectedCountsTag({
    required this.selectedCount,
    required this.closeButtonPressed,
    required this.editButtonPressed,
    required this.deleteButtonPressed,
    super.key,
  });

  final int selectedCount;
  final void Function()? closeButtonPressed;
  final void Function()? editButtonPressed;
  final void Function()? deleteButtonPressed;

  Widget _buildIconButton(
    BuildContext context,
    IconData iconData,
    void Function()? onPressedEvent,
  ) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressedEvent,
        child: Container(
          padding: const EdgeInsets.only(top: 7, left: 7, right: 7, bottom: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.transparent, width: 2.0),
          ),
          child: Icon(
            iconData,
            size: 16.0,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildIconButton(context, Icons.close, closeButtonPressed),
                horizontalSpacer8,
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    '$selectedCount Selected',
                    style: themeData.textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            horizontalSpacer10,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (selectedCount == 1)
                  _buildIconButton(
                    context,
                    Icons.edit_outlined,
                    editButtonPressed,
                  ),
                _buildIconButton(
                  context,
                  Icons.delete_outlined,
                  deleteButtonPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// List<Widget> _buildActionButtons(BuildContext context) {
//   final ColorScheme colorScheme = Theme.of(context).colorScheme;
//   final TextTheme textTheme = Theme.of(context).textTheme;
//   final ButtonStyle actionButtonStyle = TextButton.styleFrom(
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//   );
//   final TextStyle? actionButtonTextStyle = textTheme.labelLarge?.copyWith(
//     color: colorScheme.primary,
//   );
//   return <Widget>[
//     TextButton(
//       style: actionButtonStyle,
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       child: Text('Cancel', style: actionButtonTextStyle),
//     ),
//     TextButton(
//       style: actionButtonStyle,
//       onPressed: () => Navigator.pop(context),
//       child: Text('OK', style: actionButtonTextStyle),
//     ),
//   ];
// }

UserDetails setDefaultUserDetails(Profile userProfile) {
  return UserDetails(
    userProfile: userProfile,
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

Future<void> handleOnTapExportLogic(
  BuildContext context, [
  String? data,
  String? pageName,
]) async {
  // This function will be used as the onTap callback for the export button
  // final ExportService exportService = ExportService();
  // final ColorScheme colorScheme = Theme.of(context).colorScheme;
  // final TextTheme textTheme = Theme.of(context).textTheme;

  // Show the loading dialog
  showDialog<Widget>(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog by tapping outside
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 1), () async {
        // Export data
        // if (context.mounted) {
        //   final String? path = await exportService.exportSettingsToExcel(
        //     context,
        //     sheetsToExport: data != null ? <String>[data] : null,
        //   );
        //   if (context.mounted) {
        //     // After delay, close loading dialog
        //     Navigator.pop(context);

        //     // Once export is complete, show the result dialog
        //     showDialog<Widget>(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return AlertDialog(
        //           titlePadding: const EdgeInsets.all(24),
        //           contentPadding: const EdgeInsetsDirectional.only(
        //             start: 24,
        //             top: 16,
        //             end: 24,
        //             bottom: 16,
        //           ),
        //           actionsPadding: const EdgeInsets.all(24),
        //           title: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 path != null ? 'Exported' : 'Export Failed',
        //                 style: textTheme.headlineSmall?.copyWith(
        //                   color: colorScheme.onSurface,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 5),
        //                 child: IconButton(
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   },
        //                   icon: const Icon(
        //                     IconData(0xe721, fontFamily: fontIconFamily),
        //                     size: 24,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           content: path != null
        //               ? Row(
        //                   spacing: 8.0,
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: <Widget>[
        //                     Expanded(
        //                       child: Text(
        //                         '$pageName data exported to:\n$path',
        //                         overflow: TextOverflow.ellipsis,
        //                         maxLines: 3,
        //                         style: textTheme.bodyLarge?.copyWith(
        //                           color: colorScheme.onSurface,
        //                         ),
        //                       ),
        //                     ),
        //                     IconButton(
        //                       icon: const Icon(Icons.copy),
        //                       onPressed: () {
        //                         // Copy path to clipboard
        //                         Clipboard.setData(ClipboardData(text: path));
        //                         ScaffoldMessenger.of(context).showSnackBar(
        //                           const SnackBar(
        //                             content: Text('Path copied to clipboard!'),
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                   ],
        //                 )
        //               : Text(
        //                   'No $pageName data found to export.',
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 3,
        //                   style: textTheme.bodyLarge?.copyWith(
        //                     color: colorScheme.onSurface,
        //                   ),
        //                 ),
        //           actions: _buildActionButtons(context),
        //         );
        //       },
        //     );
        //   }
        // }
      });

      // Return a loading indicator while waiting
      return const Center(child: CircularProgressIndicator());
    },
  );
}

void showMobileDeleteConfirmation(
  BuildContext context,
  String title,
  String subTitle,
  void Function()? onPressed,
) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 32,
          right: 24,
          left: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            verticalSpacer30,
            Flexible(
              child: Text(
                subTitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            verticalSpacer44,
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: colorScheme.error),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  'Delete',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Map<String, String> separateCurrency(String input) {
  input = input.trim();

  // Check for currency prefix (e.g., "$500")
  final RegExp prefixPattern = RegExp(r'^(\D+)([\d.,]+)$');
  if (prefixPattern.hasMatch(input)) {
    final RegExpMatch match = prefixPattern.firstMatch(input)!;
    return {
      'currency': match.group(1)!.trim(),
      'amount': match.group(2)!.replaceAll(RegExp(r'[,]'), ''),
    };
  }

  // Check for currency suffix (e.g., "500€")
  final RegExp suffixPattern = RegExp(r'^([\d.,]+)(\D+)$');
  if (suffixPattern.hasMatch(input)) {
    final RegExpMatch match = suffixPattern.firstMatch(input)!;
    return {
      'currency': match.group(2)!.trim(),
      'amount': match.group(1)!.replaceAll(RegExp(r'[,]'), ''),
    };
  }

  // Fallback for numbers without currency symbols
  return {'currency': '', 'amount': input};
}
