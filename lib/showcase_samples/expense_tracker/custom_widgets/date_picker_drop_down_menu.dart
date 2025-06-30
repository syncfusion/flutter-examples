import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_core/core.dart';

import '../constants.dart';
import '../helper/responsive_layout.dart';

class ChartsDropdownFilter extends StatefulWidget {
  const ChartsDropdownFilter({
    required this.onTap,
    required this.selectedDuration,
    required this.intervalFilters,
    super.key,
    this.horizontalPadding,
    this.showLeadingIcon = true,
    this.width,
  });
  final ValueChanged<String?>? onTap;
  final String? selectedDuration;
  final List<String> intervalFilters;
  final bool showLeadingIcon;
  final double? horizontalPadding;
  final double? width;

  @override
  ChartsDropdownFilterState createState() => ChartsDropdownFilterState();
}

class ChartsDropdownFilterState extends State<ChartsDropdownFilter> {
  bool isPopupOpen = false;
  late double dropdownWidth;

  @override
  void didChangeDependencies() {
    dropdownWidth = _calculateDropdownWidth();
    super.didChangeDependencies();
  }

  double _calculateDropdownWidth() {
    final ThemeData themeData = Theme.of(context);
    double maxWidth = 0;
    final TextStyle style = themeData.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.w400,
      color: themeData.colorScheme.onSurfaceVariant,
    );
    for (final value in widget.intervalFilters) {
      final Size size = measureText(value, style);
      if (size.width > maxWidth) {
        maxWidth = size.width;
      }
    }
    const double iconWidth = 18.0;
    const double trailingIconWidth = 18.0;
    const double padding = 28.0;
    const double extraSpacing = 26.0;
    return maxWidth + iconWidth + trailingIconWidth + padding + extraSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (!isMobile(context)) {
          if (isPopupOpen) {
            Navigator.of(context).maybePop();
            isPopupOpen = false;
          }
        }

        if (isMobile(context) ||
            (isTablet(context) && widget.showLeadingIcon)) {
          return Theme(
            data: ThemeData(
              hoverColor: themeData.colorScheme.primaryContainer,
              highlightColor: themeData.colorScheme.primaryContainer,
              // menuPadding: const EdgeInsets.symmetric(
              //   horizontal: 16,
              //   vertical: 8,
              // ),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                onSelected: widget.onTap,
                color: themeData.colorScheme.onPrimary,
                surfaceTintColor: themeData.colorScheme.onPrimary,
                elevation: 4,
                iconSize: 24,
                tooltip: '',
                iconColor: themeData.colorScheme.onSurfaceVariant,
                position: PopupMenuPosition.under,
                icon: const Icon(
                  IconData(0xe72b, fontFamily: fontIconFamily),
                  // color: themeData.colorScheme.onSurfaceVariant,
                  // size: 32.0,
                ),
                itemBuilder: (context) {
                  return widget.intervalFilters.map((String value) {
                    return PopupMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: themeData.textTheme.labelLarge!.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          );
        }

        return DropdownMenuTheme(
          data: DropdownMenuThemeData(
            menuStyle: MenuStyle(
              fixedSize: const WidgetStatePropertyAll(
                Size(200, double.infinity),
              ),
              mouseCursor: const WidgetStatePropertyAll(
                MouseCursor.uncontrolled,
              ),
              alignment: Alignment.bottomLeft,
              elevation: const WidgetStatePropertyAll(4),
              side: WidgetStatePropertyAll(
                BorderSide(color: themeData.colorScheme.outlineVariant),
              ),
              shadowColor: WidgetStatePropertyAll(
                themeData.colorScheme.outlineVariant,
              ),
              backgroundColor: WidgetStatePropertyAll(
                themeData.colorScheme.onPrimary,
              ),
              surfaceTintColor: WidgetStatePropertyAll(
                themeData.colorScheme.onPrimary,
              ),
            ),
            textStyle: themeData.textTheme.labelLarge!.copyWith(
              color: themeData.colorScheme.onSurfaceVariant,
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding ?? 0.0,
                vertical: 8.0,
              ),
              constraints: const BoxConstraints(maxHeight: 40.0),
              isDense: true,
              iconColor: themeData.colorScheme.onSurfaceVariant,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: themeData.colorScheme.outlineVariant,
                ),
              ),
              outlineBorder: BorderSide(
                color: themeData.colorScheme.outlineVariant,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: themeData.colorScheme.outlineVariant,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: themeData.colorScheme.outlineVariant,
                ),
              ),
              activeIndicatorBorder: BorderSide(
                color: themeData.colorScheme.outlineVariant,
              ),
              fillColor: themeData.colorScheme.surface,
              filled: true,
            ),
          ),
          child: DropdownMenu<String>(
            requestFocusOnTap: false,
            inputFormatters: const [],
            width: widget.width ?? _calculateDropdownWidth(),
            leadingIcon: widget.showLeadingIcon
                ? Icon(
                    const IconData(0xe72b, fontFamily: fontIconFamily),
                    color: themeData.colorScheme.onSurfaceVariant,
                    size: 18.0,
                  )
                : null,
            textAlign: TextAlign.left,
            trailingIcon: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Icon(
                Icons.arrow_drop_down,
                size: 18.0,
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
            selectedTrailingIcon: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Icon(
                Icons.arrow_drop_down,
                size: 18.0,
                color: themeData.colorScheme.onSurfaceVariant,
              ),
            ),
            enableSearch: false,
            textStyle: themeData.textTheme.bodyLarge!.copyWith(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: themeData.colorScheme.onSurfaceVariant,
            ),
            keyboardType: TextInputType.none,
            initialSelection: widget.selectedDuration,
            onSelected: widget.onTap,
            dropdownMenuEntries: List.generate(widget.intervalFilters.length, (
              int index,
            ) {
              final isSelected =
                  widget.selectedDuration == widget.intervalFilters[index];
              return DropdownMenuEntry<String>(
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  ),
                  // overlayColor: WidgetStatePropertyAll(
                  //   themeData.colorScheme.,
                  // ),
                  backgroundColor: WidgetStatePropertyAll(
                    isSelected
                        ? themeData.colorScheme.primaryContainer
                        : themeData.colorScheme.surfaceContainerLow,
                  ),
                ),
                value: widget.intervalFilters[index],
                label: widget.intervalFilters[index],
              );
            }),
          ),
        );
      },
    );
  }
}
