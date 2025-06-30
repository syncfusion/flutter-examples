// flutter_examples/lib/showcase_samples/stock_analysis/dialogs/disclaimer_popup.dart
import 'package:flutter/material.dart';
import '../helper/helper.dart';

class DisclaimerPopup extends StatefulWidget {
  const DisclaimerPopup({super.key});

  @override
  State<DisclaimerPopup> createState() => _DisclaimerPopupState();
}

class _DisclaimerPopupState extends State<DisclaimerPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.all(24.0),
      title: _buildDisclaimerHeader(context),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * (1 / 3),
        child: Text(
          'The stock data displayed here is for demonstration purposes only and represents the period from January 01, 2023 to January 01, 2025. This information does not reflect any actual market values or investment performances.',
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}

Widget _buildDisclaimerHeader(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildDisclaimerText(context),
      buildCloseIconButton(context, () {
        Navigator.of(context).pop();
      }),
    ],
  );
}

Widget _buildDisclaimerText(BuildContext context) {
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return Text(
    'Disclaimer',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: colorScheme.onSurface,
      fontWeight: fontWeight500(),
    ),
  );
}

// Helper function to show the disclaimer popup
Future<void> showDisclaimerPopup(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return const DisclaimerPopup();
    },
  );
}
