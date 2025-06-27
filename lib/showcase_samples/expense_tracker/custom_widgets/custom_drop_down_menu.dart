import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    required this.items,
    required this.controller,
    required this.focusNode,
    super.key,
    this.selectedValue,
    this.initialValue,
    this.hintText,
    this.onSelected,
    this.isRequired = true,
    this.expandedInsets,
    this.enable = true,
  });

  final List<String> items;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? initialValue;
  final String? hintText;
  final ValueChanged<String?>? onSelected;
  final bool isRequired;
  final EdgeInsetsGeometry? expandedInsets;
  final bool enable;
  final String? selectedValue;

  @override
  State createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late FocusNode _focusNode;
  late ValueNotifier<bool> _isFocusedNotifier;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode;
    _isFocusedNotifier = ValueNotifier<bool>(_focusNode.hasFocus);

    _focusNode.addListener(() {
      _isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle bodyLarge = themeData.textTheme.bodyLarge!;
    final Color onSurface = themeData.colorScheme.onSurface;

    return ValueListenableBuilder(
      valueListenable: _isFocusedNotifier,
      builder: (context, isFocused, child) {
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
          ),
          child: DropdownMenu<String>(
            requestFocusOnTap: false,
            controller: widget.controller,
            enableSearch: false,
            keyboardType: TextInputType.none,
            focusNode: widget.focusNode,
            inputFormatters: const <TextInputFormatter>[],
            expandedInsets: widget.expandedInsets,
            textStyle: bodyLarge.copyWith(color: onSurface),
            initialSelection: widget.selectedValue,
            onSelected: widget.onSelected,
            inputDecorationTheme: InputDecorationTheme(
              alignLabelWithHint: true,
              hintStyle: themeData.textTheme.bodyLarge!.copyWith(
                color: themeData.colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              contentPadding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 2.0,
                bottom: 10.0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: themeData.colorScheme.outline),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: themeData.colorScheme.error),
              ),
            ),
            label: RichText(
              text: TextSpan(
                text: widget.hintText,
                style: themeData.textTheme.bodyMedium!.copyWith(
                  color: isFocused
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.onSurfaceVariant,
                ),
                children: <InlineSpan>[
                  if (widget.isRequired)
                    TextSpan(
                      text: '*',
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: themeData.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            hintText: widget.hintText,
            dropdownMenuEntries: List.generate(
              widget.items.isEmpty ? 1 : widget.items.length,
              (int index) {
                final bool isSelected = widget.items.isEmpty
                    ? false
                    : widget.items[index] == widget.selectedValue;
                return widget.items.isEmpty
                    ? DropdownMenuEntry<String>(
                        enabled: false,
                        style: ButtonStyle(
                          overlayColor: WidgetStatePropertyAll(
                            themeData.colorScheme.primaryContainer,
                          ),
                        ),
                        value: 'No Records Found',
                        label: 'No Records Found',
                      )
                    : DropdownMenuEntry<String>(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            isSelected
                                ? themeData.colorScheme.primaryContainer
                                : null,
                          ),
                          overlayColor: WidgetStatePropertyAll(
                            themeData.colorScheme.primaryContainer,
                          ),
                        ),
                        value: widget.items[index],
                        label: widget.items[index],
                      );
              },
            ),
          ),
        );
      },
    );
  }
}
