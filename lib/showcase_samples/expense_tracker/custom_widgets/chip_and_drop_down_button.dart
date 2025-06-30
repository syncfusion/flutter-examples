import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helper/responsive_layout.dart';

/// Segmented button allowing multiple selection options.
class SegmentedFilterButtons extends StatefulWidget {
  const SegmentedFilterButtons({
    required this.options,
    required this.onSelectionChanged,
    required this.selectedSegment,
    this.icons, // Optional parameter for icons
    super.key,
  });

  final List<String> options;
  final void Function(Set<String>)? onSelectionChanged;
  final String selectedSegment;
  final List<IconData>? icons;
  @override
  State<SegmentedFilterButtons> createState() => _SegmentedFilterButtonsState();
}

class _SegmentedFilterButtonsState extends State<SegmentedFilterButtons> {
  late String _selectedSegment;

  /// Constructs the style for the segmented button.
  ButtonStyle _segmentedButtonStyle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SegmentedButton.styleFrom(
      visualDensity: const VisualDensity(vertical: -0.5),
      padding: _segmentedEdgeInsets(context),
      side: BorderSide(width: 0.0, color: colorScheme.primary),
      textStyle: isMobile(context)
          ? Theme.of(context).textTheme.titleSmall
          : Theme.of(context).textTheme.titleMedium,
      backgroundColor: colorScheme.surface,
      selectedBackgroundColor: colorScheme.primary,
      selectedForegroundColor: colorScheme.onPrimary,
      elevation: 2.0,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );
  }

  EdgeInsets _segmentedEdgeInsets(BuildContext context) {
    final bool isMobileDevice = isMobile(context);
    double? top;
    double? bottom;

    if (kIsWeb) {
      top = 10.0;
      bottom = 14.0;
    } else if (Platform.isWindows && !isMobile(context)) {
      top = 8.0;
      bottom = 16.0;
    } else {
      top = 12.0;
      bottom = 12.0;
    }
    return EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: isMobileDevice ? 16.0 : 24.0,
      right: isMobileDevice ? 16.0 : 24.0,
    );
  }

  /// Builds segments for the options provided.
  List<ButtonSegment<String>> _buildSegments() {
    final List<String> options = widget.options;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool hasIcons = widget.icons != null && widget.icons!.isNotEmpty;

    return List<ButtonSegment<String>>.generate(options.length, (int index) {
      final bool isSelected = options[index] == _selectedSegment;

      // For small screens, show only icons if available
      if (isMobile(context) && hasIcons && index < widget.icons!.length) {
        return ButtonSegment(
          value: options[index],
          label: Center(
            child: Icon(
              widget.icons![index],
              size: 20,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }

      // For larger screens or when icons aren't available, show text
      return ButtonSegment(
        value: options[index],
        label: Text(options[index], overflow: TextOverflow.ellipsis),
      );
    });
  }

  /// Handles the selection change in the segmented button.
  void _onSelectionChanged(Set<String> selectedSegment) {
    setState(() {
      _selectedSegment = selectedSegment.first;
    });

    widget.onSelectionChanged?.call(selectedSegment);
  }

  @override
  void initState() {
    _selectedSegment = widget.selectedSegment;
    super.initState();
  }

  @override
  void didUpdateWidget(SegmentedFilterButtons oldWidget) {
    if (oldWidget.selectedSegment != widget.selectedSegment) {
      _selectedSegment = widget.selectedSegment;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return isMobile(context)
        ? _buildSegmentedButton(context)
        : SizedBox(height: 40.0, child: _buildSegmentedButton(context));
  }

  SegmentedButton<String> _buildSegmentedButton(BuildContext context) {
    return SegmentedButton(
      style: _segmentedButtonStyle(context),
      segments: _buildSegments(),
      selected: {_selectedSegment},
      onSelectionChanged: _onSelectionChanged,
      showSelectedIcon: false,
    );
  }
}
