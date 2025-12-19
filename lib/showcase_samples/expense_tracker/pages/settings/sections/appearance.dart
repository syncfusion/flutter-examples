import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
// import '../../../data_processing/utils.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/user_profile.dart';
import '../../../notifiers/theme_notifier.dart';
import '../../base_home.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage(this.userProfile, {super.key});

  final Profile userProfile;

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  late String _initialTheme;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initialTheme = widget.userProfile.themeFormat;
  }

  void _updateTheme(String newTheme) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(
      context,
      listen: false,
    );
    themeNotifier.updateTheme(newTheme);
    setState(() {
      _hasChanges = themeNotifier.selectedTheme != _initialTheme;
    });
  }

  void _handleUpdate() {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(
      context,
      listen: false,
    );

    switch (themeNotifier.selectedTheme) {
      case 'System Default':
        themeNotifier.setSystemTheme();
        break;
      case 'Light':
        themeNotifier.setLightTheme();
        break;
      case 'Dark':
        themeNotifier.setDarkTheme();
        break;
    }

    widget.userProfile.themeFormat = themeNotifier.selectedTheme;
    // updateUserProfile(context, widget.userProfile);
    pageNavigatorNotifier.value = NavigationPagesSlot.settings;
  }

  Column _buildSettingsFields(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(
      context,
      listen: false,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildThemeOption('Light', colorScheme, textTheme, themeNotifier),
        verticalSpacer8,
        _buildThemeOption('Dark', colorScheme, textTheme, themeNotifier),
        verticalSpacer8,
        _buildThemeOption(
          'System Default',
          colorScheme,
          textTheme,
          themeNotifier,
        ),
        const Spacer(),
        // Bottom buttons
        Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
        verticalSpacer24,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 4,
                right: 4,
                top: 2,
                bottom: 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                child: TextButton(
                  onPressed: () => pageNavigatorNotifier.value =
                      NavigationPagesSlot.settings,
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  child: const Text('Discard'),
                ),
              ),
            ),
            horizontalSpacer12,
            Container(
              padding: const EdgeInsets.only(
                left: 4,
                right: 4,
                top: 2,
                bottom: 2,
              ),
              decoration: BoxDecoration(
                color: _hasChanges ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: _hasChanges ? Colors.transparent : colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: 4,
                  top: 2,
                  bottom: 2,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    disabledForegroundColor: colorScheme.onSurface,
                  ),
                  onPressed: _hasChanges ? _handleUpdate : null,
                  child: Text(
                    'Update',
                    style: textTheme.titleSmall?.copyWith(
                      color: _hasChanges ? colorScheme.onPrimary : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile(context) ? 24.0 : 24.0,
        horizontal: isMobile(context) ? 24.0 : 24.0,
      ),
      child: isMobile(context)
          ? _buildSettingsFields(context)
          : ExpenseCard(
              edgeInsets: EdgeInsets.symmetric(
                horizontal: isMobile(context) ? 0 : 32.0,
                vertical: isMobile(context) ? 0 : 32.0,
              ),
              child: _buildSettingsFields(context),
            ),
    );
  }

  Widget _buildThemeOption(
    String title,
    ColorScheme colorScheme,
    TextTheme textTheme,
    ThemeNotifier themeNotifier,
  ) {
    return InkWell(
      onTap: () => _updateTheme(title),
      child: RadioGroup<String>(
        groupValue: themeNotifier.selectedTheme,
        onChanged: (value) => _updateTheme(value!),
        child: Row(
          children: [
            Center(child: Radio<String>(value: title)),
            horizontalSpacer14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
