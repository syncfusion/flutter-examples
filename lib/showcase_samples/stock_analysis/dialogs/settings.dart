import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum.dart';
import '../helper/helper.dart';
import '../helper/responsive_layout.dart';
import '../model/chart_settings.dart';
import '../notifier/stock_chart_notifier.dart';
import 'mobile_dialog.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  Widget _buildMobileView(BuildContext context) {
    return MobileDialog(
      dialogType: 'Settings',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: _buildSettingsContent(context),
      ),
      action: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(width: 8.0),
          TextButton(
            onPressed: () {
              context.read<StockChartProvider>().applySettings();
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        width: 500,
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: 24.0,
          top: 18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            const SizedBox(height: 16.0),
            Flexible(child: _buildSettingsContent(context)),
            const SizedBox(height: 34.0),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return deviceType(context) == DeviceType.desktop
        ? _buildDesktopView(context)
        : _buildMobileView(context);
  }

  Widget _buildHeader(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Settings',
          style: themeData.textTheme.headlineSmall?.copyWith(
            color: themeData.colorScheme.onSurface,
          ),
        ),
        buildCloseIconButton(context, () {
          context.read<StockChartProvider>().resetTempSettings();
          Navigator.of(context).pop();
        }),
      ],
    );
  }

  Widget _buildSettingsContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBasicChartOptions(context),
          const SizedBox(height: 12.0),
          _buildYAxisOptions(context),
          const SizedBox(height: 12.0),
          _buildAxisConfigurationOptions(context),
          const SizedBox(height: 12.0),
          Text(
            'Chart Range Control',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: fontWeight500(),
            ),
          ),
          _buildCheckboxOption(
            context: context,
            title: 'Enable Range Selector',
            settingSelector: (ChartSettings settings) =>
                settings.rangeSelectorEnabled,
            onChanged: (bool? value) => context
                .read<StockChartProvider>()
                .updateTempSetting(rangeSelectorEnabled: value),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicChartOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Chart Interactions',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        _buildCheckboxOption(
          context: context,
          title: 'Enable Tooltip',
          settingSelector: (ChartSettings settings) => settings.tooltipEnabled,
          onChanged: (bool? value) => context
              .read<StockChartProvider>()
              .updateTempSetting(tooltipEnabled: value),
        ),
      ],
    );
  }

  Widget _buildAxisConfigurationOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Chart Axis Positioning',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        _buildCheckboxOption(
          context: context,
          title: 'Opposed Axis',
          settingSelector: (ChartSettings settings) => settings.opposedAxis,
          onChanged: (bool? value) => context
              .read<StockChartProvider>()
              .updateTempSetting(opposedAxis: value),
        ),
        _buildCheckboxOption(
          context: context,
          title: 'Inverted Axis',
          settingSelector: (ChartSettings settings) => settings.invertedAxis,
          onChanged: (bool? value) => context
              .read<StockChartProvider>()
              .updateTempSetting(invertedAxis: value),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption({
    required BuildContext context,
    required String title,
    TextStyle? style,
    required bool Function(ChartSettings) settingSelector,
    required ValueChanged<bool?> onChanged,
  }) {
    return Selector<StockChartProvider, bool>(
      selector: (BuildContext context, StockChartProvider provider) =>
          settingSelector(provider.tempSettings),
      builder: (BuildContext context, bool value, Widget? child) {
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: style != null ? EdgeInsets.zero : null,
          title: Text(
            title,
            style:
                style ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: fontWeight400(),
                ),
          ),
          value: value,
          onChanged: onChanged,
        );
      },
    );
  }

  Widget _buildYAxisOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Chart Axis Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: fontWeight500(),
          ),
        ),
        Selector<StockChartProvider, bool>(
          selector: (BuildContext context, StockChartProvider provider) =>
              provider.tempSettings.logarithmicYAxis,
          builder: (BuildContext context, bool isLogarithmic, Widget? child) =>
              RadioGroup<bool>(
                groupValue: isLogarithmic,
                onChanged: (bool? value) {
                  if (value != null) {
                    context.read<StockChartProvider>().updateTempSetting(
                      logarithmicYAxis: value,
                    );
                  }
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text(
                          'Numeric Axis',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: fontWeight400(),
                              ),
                        ),
                        value: false,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text(
                          'Log Axis',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: fontWeight400(),
                              ),
                        ),
                        value: true,
                      ),
                    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8.0),
        // TextButton(
        // onPressed: () {
        // context.read<StockChartProvider>().applySettings();
        // },
        // child: const Text('Save'),
        // ),
        // const SizedBox(width: 8.0),
        TextButton(
          onPressed: () {
            context.read<StockChartProvider>().applySettings();
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
