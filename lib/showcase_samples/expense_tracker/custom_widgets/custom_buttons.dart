import 'package:flutter/material.dart';

import '../constants.dart';
import '../helper/responsive_layout.dart';

/// Creates a custom add button responsive to the device type.
class AddButton extends StatelessWidget {
  const AddButton({required this.onTap, super.key});

  final VoidCallback onTap;

  Widget _buildMobileAddButton(VoidCallback onTap, ThemeData themeData) {
    return GestureDetector(
      onTap: onTap,
      child: _buildIconContainer(
        themeData,
        Icons.add,
        themeData.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildAddButton(
    VoidCallback onTap,
    ThemeData themeData,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: _elevatedButtonStyle(themeData),
      child: Center(
        child: Text(
          'Add',
          style: themeData.textTheme.labelLarge!.copyWith(
            color: themeData.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return isMobile(context)
        ? _buildMobileAddButton(onTap, themeData)
        : _buildAddButton(onTap, themeData, context);
  }
}

class ExportButton extends StatelessWidget {
  const ExportButton({required this.onTap, super.key});

  final VoidCallback onTap;

  Widget _buildExportButton(
    VoidCallback onTap,
    ThemeData themeData,
    BuildContext context,
  ) {
    ButtonStyle elevatedExportButtonStyle(ThemeData themeData) {
      return ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: themeData.colorScheme.surface,
        surfaceTintColor: themeData.colorScheme.surface,
        alignment: Alignment.center,
        overlayColor: themeData.colorScheme.surfaceContainer,
        side: BorderSide(color: themeData.colorScheme.outlineVariant),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 24.0,
          top: 10.0,
          bottom: 10.0,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: elevatedExportButtonStyle(themeData),
      child: Center(
        child: Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildExportIcon(themeData),
            Text(
              'Export',
              overflow: TextOverflow.ellipsis,
              style: _elevatedButtonTextStyle(context, themeData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportIcon(ThemeData themeData) {
    return Icon(
      const IconData(0xe733, fontFamily: fontIconFamily),
      color: themeData.colorScheme.onSurfaceVariant,
      size: 18.0,
    );
  }

  /// Builds an export button tailored for different device types.
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return _buildExportButton(onTap, themeData, context);
  }
}

/// Builds the custom box with an icon for the mobile view.
Widget _buildIconContainer(ThemeData themeData, IconData icon, Color color) {
  return Center(
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Icon(icon, size: 18, color: color),
      ),
    ),
  );
}

/// Defines button styles for Elevated buttons.
ButtonStyle _elevatedButtonStyle(ThemeData themeData) {
  return ElevatedButton.styleFrom(
    elevation: 2.0,
    backgroundColor: themeData.colorScheme.primary,
    surfaceTintColor: themeData.colorScheme.primary,
    alignment: Alignment.center,
    shadowColor: themeData.colorScheme.outline,
    overlayColor: themeData.colorScheme.primaryContainer,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  );
}

/// Text style for buttons in ElevatedButton.
TextStyle _elevatedButtonTextStyle(BuildContext context, ThemeData themeData) {
  return themeData.textTheme.labelLarge!.copyWith(
    color: themeData.colorScheme.onSurfaceVariant,
  );
}

/// Reusable action buttons for dialogs or forms.
class CustomTextActionButtons extends StatelessWidget {
  const CustomTextActionButtons({
    required this.onCancelAction,
    required this.onAddOrEditAction,
    required this.showEditButton,
    super.key,
    this.showSaveButton = false,
  });

  final VoidCallback onCancelAction;
  final VoidCallback? onAddOrEditAction;
  final bool showEditButton;
  final bool showSaveButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CustomTextButtons(onPressed: onCancelAction, text: 'Cancel'),
        CustomTextButtons(
          onPressed: onAddOrEditAction,
          text: showSaveButton
              ? 'Save'
              : showEditButton
              ? 'Save'
              : 'Create',
        ),
      ],
    );
  }
}

class CustomTextButtons extends StatelessWidget {
  const CustomTextButtons({
    required this.onPressed,
    required this.text,
    super.key,
    this.color,
  });

  final void Function()? onPressed;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: themeData.textTheme.labelLarge!.copyWith(
          color: onPressed == null
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
