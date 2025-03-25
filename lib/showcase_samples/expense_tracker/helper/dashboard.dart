import 'package:flutter/material.dart';
import 'responsive_layout.dart';

Widget buildHeaderText(
  BuildContext context,
  String headerText, [
  int? maxLines,
]) {
  final ThemeData themeData = Theme.of(context);
  final TextTheme textTheme = themeData.textTheme;
  final Color headerTextColor = themeData.colorScheme.onSecondaryContainer;
  return Text(
    headerText,
    maxLines: maxLines ?? 1,
    overflow: TextOverflow.ellipsis,
    style: textTheme.titleMedium!.copyWith(
      color: headerTextColor,
      fontWeight: FontWeight.w600,
    ),
  );
}

class DropDownButtonWidget extends StatelessWidget {
  const DropDownButtonWidget({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: SizedBox(
        height: 32.0,
        child: DropdownButton<String>(
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          value: value,
          icon: const Center(child: Icon(size: 24, Icons.arrow_drop_down)),
          items: List<DropdownMenuItem<String>>.generate(items.length, (
            int index,
          ) {
            return DropdownMenuItem<String>(
              value: items[index],
              child: Center(child: Text(items[index])),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.edgeInsets,
    this.globalKey,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? edgeInsets;
  final GlobalKey? globalKey;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: globalKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 1),
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ],
      ),
      child: Padding(
        padding:
            edgeInsets ??
            (isMobile(context)
                ? const EdgeInsets.all(16.0)
                : const EdgeInsets.all(24.0)),
        child: child,
      ),
    );
  }
}
