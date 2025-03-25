import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/theme.dart';

SfDataGridThemeData dataGridTheme(BuildContext context) {
  final ThemeData themeData = Theme.of(context);

  final Color gridColor = themeData.colorScheme.outlineVariant;
  return SfDataGridThemeData(
    headerHoverColor: Colors.transparent,
    headerColor: themeData.colorScheme.surface,
    selectionColor: themeData.colorScheme.secondaryContainer,
    currentCellStyle: const DataGridCurrentCellStyle(
      borderColor: Colors.transparent,
      borderWidth: 0,
    ),
    gridLineColor: gridColor,
    gridLineStrokeWidth: 1,
  );
}

SfDataPagerThemeData dataPagerTheme(BuildContext context) {
  return SfDataPagerThemeData(
    backgroundColor: Colors.transparent,
    selectedItemTextStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
    selectedItemColor: Theme.of(context).colorScheme.primary,
    itemTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    ),
    itemBorderRadius: BorderRadius.circular(5),
  );
}
