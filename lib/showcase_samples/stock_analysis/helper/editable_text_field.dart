import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../expense_tracker/constants.dart';
import '../model/user_detail.dart';
import '../notifier/stock_chart_notifier.dart';
import 'helper.dart';

class NameTextField extends StatefulWidget {
  const NameTextField({
    Key? key,
    required this.label,
    required this.initialValue,
    this.isFirstName = true,
  }) : super(key: key);

  final String label;
  final String initialValue;
  final bool isFirstName;

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  late String _initialValue;

  @override
  void initState() {
    super.initState();
    if (widget.isFirstName) {
      _firstNameController.text = widget.initialValue;
      _initialValue = widget.initialValue;
    } else {
      _lastNameController.text = widget.initialValue;
      _initialValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: widget.isFirstName
          ? _buildFirstNameField(context)
          : _buildLastNameField(context),
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return _buildTextField(
      context: context,
      label: widget.label,
      controller: _firstNameController,
      focusNode: _firstNameFocusNode,
      isEditableKey: 'First',
      onUpdate: (String value) {
        provider.user = UserDetail(
          firstName: value,
          lastName: provider.user.lastName,
        );
      },
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    final StockChartProvider provider = context.read<StockChartProvider>();
    return _buildTextField(
      context: context,
      label: widget.label,
      controller: _lastNameController,
      focusNode: _lastNameFocusNode,
      isEditableKey: 'Last',
      onUpdate: (String value) {
        provider.user = UserDetail(
          firstName: provider.user.firstName,
          lastName: value,
        );
      },
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String isEditableKey,
    required ValueChanged<String> onUpdate,
  }) {
    final provider = context.read<StockChartProvider>();
    final TextStyle? labelTextStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: fontWeight400(),
        );
    const double textPadding = 24;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelTextStyle),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                width:
                    _measureTextSize(controller.text, labelTextStyle).width +
                    textPadding,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: labelTextStyle,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12, right: 8),
                    border: OutlineInputBorder(),
                  ),
                  onTapOutside: (PointerDownEvent event) {
                    focusNode.unfocus();
                  },
                  onChanged: (String value) {
                    provider.isEditableTextMap[isEditableKey] = true;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (provider.isEditableTextMap[isEditableKey]!)
                InkWell(
                  onTap: () {
                    if (controller.text.isNotEmpty) {
                      _initialValue = controller.text;
                      onUpdate(controller.text);
                      setState(() {
                        provider.isEditableTextMap[isEditableKey] = false;
                      });
                    } else {
                      setState(() {
                        controller.text = _initialValue;
                        provider.isEditableTextMap[isEditableKey] = false;
                      });
                    }
                  },
                  child: Icon(
                    Icons.check,
                    size: 18,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

Size _measureTextSize(String text, TextStyle? style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();
  return textPainter.size;
}
