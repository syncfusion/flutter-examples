import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../custom_widgets/custom_buttons.dart';
import '../../helper/common_helper.dart';
import '../../helper/dashboard.dart';
import '../../helper/responsive_layout.dart';
import '../../models/transactional_data.dart';
import '../../models/transactional_details.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../notifiers/import_notifier.dart';
import '../../notifiers/restart_notifier.dart';
import '../base_home.dart';
import 'sections/appearance.dart';
import 'sections/personalization.dart';
import 'sections/profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.currentUserDetails, {super.key});

  final UserDetails currentUserDetails;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;
  final ValueNotifier<bool> _showCategoryPage = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isHovered = ValueNotifier<bool>(false);
  late Profile _userProfile;
  final ValueNotifier<bool> _showAppearancePage = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showPersonalizationPage = ValueNotifier<bool>(
    false,
  );
  final ValueNotifier<bool> _showProfilePage = ValueNotifier<bool>(false);

  @override
  void initState() {
    _userProfile = widget.currentUserDetails.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    _colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isMobile(context) ? 16.0 : 24.0,
        horizontal: isMobile(context) ? 16.0 : 24.0,
      ),
      child: isMobile(context)
          ? _buildSettingsPageContent()
          : ExpenseCard(child: _buildSettingsPageContent()),
    );
  }

  Widget _buildSettingsPageContent() {
    return ValueListenableBuilder(
      valueListenable: _showProfilePage,
      builder: (BuildContext context, bool showProfile, Widget? child) {
        if (showProfile) {
          return ProfilePage(_userProfile);
        }
        return ValueListenableBuilder(
          valueListenable: _showPersonalizationPage,
          builder:
              (BuildContext context, bool showPersonalization, Widget? child) {
                if (showPersonalization) {
                  return PersonalizationPage(_userProfile);
                }
                return ValueListenableBuilder(
                  valueListenable: _showAppearancePage,
                  builder:
                      (
                        BuildContext context,
                        bool showAppearance,
                        Widget? child,
                      ) {
                        if (showAppearance) {
                          return AppearancePage(_userProfile);
                        }
                        return ValueListenableBuilder(
                          valueListenable: _showCategoryPage,
                          builder:
                              (
                                BuildContext context,
                                bool value,
                                Widget? child,
                              ) {
                                return _buildSettingsPage();
                              },
                        );
                      },
                );
              },
        );
      },
    );
  }

  String _getInitials() {
    final String firstName = widget.currentUserDetails.userProfile.firstName;
    final String lastName = widget.currentUserDetails.userProfile.lastName;

    String initials = '';
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }
    return initials;
  }

  // Add this method in the _SettingsPageState class
  Future<void> _showResetConfirmationDialog() async {
    bool isConfirmed = false;

    if (!mounted) {
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              scrollable: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reset Data',
                    style: _textTheme.titleLarge?.copyWith(
                      color: _colorScheme.error,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: IconButton(
                      icon: const Icon(
                        IconData(0xe721, fontFamily: fontIconFamily),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to reset the data?',
                    style: _textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Text('This will:', style: _textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    '• Delete all your data\n• Clear all settings',
                    style: _textTheme.bodyMedium?.copyWith(
                      color: _colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This action cannot be undone.',
                    style: _textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isConfirmed,
                        onChanged: (bool? value) {
                          setState(() {
                            isConfirmed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I understand that this will permanently delete all my data',
                          style: _textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: _textTheme.labelLarge?.copyWith(
                      color: _colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isConfirmed
                      ? () async {
                          try {
                            Navigator.of(dialogContext).pop();
                            await _deleteAppData();
                            if (mounted) {
                              await _restartApp();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext errorContext) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text('Failed to reset: $e'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(errorContext).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                    disabledForegroundColor: _colorScheme.error,
                    foregroundColor: _colorScheme.error,
                  ),
                  child: Text(
                    'Reset',
                    style: _textTheme.labelLarge!.copyWith(
                      color: isConfirmed
                          ? _colorScheme.error
                          : _colorScheme.error.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Reset Data Implementation
  Future<void> _deleteAppData() async {
    try {
      if (kIsWeb) {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        await preferences.remove('excel_data');
      } else {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final File excelFile = File(
          '${appDir.path}\\Expense Tracker Data.xlsx',
        );
        if (excelFile.existsSync()) {
          await excelFile.delete();
        }
      }
    } catch (e) {
      throw Exception('Failed to delete app data: $e');
    }
  }

  Future<void> _restartApp() async {
    final RestartAppNotifier restartAppNotifier =
        Provider.of<RestartAppNotifier>(context, listen: false);

    restartAppNotifier.isRestartedAPP();
    Provider.of<ImportNotifier>(
      context,
      listen: false,
    ).resetAppData(widget.currentUserDetails.userProfile);

    // Navigate to dashboard page
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ExpenseAnalysis(currentUserDetails: _defaultUserDetails()),
      ),
      (Route<void> route) => true,
    );
  }

  UserDetails _defaultUserDetails() {
    return UserDetails(
      userProfile: widget.currentUserDetails.userProfile,
      transactionalData: TransactionalData(
        data: TransactionalDetails(
          transactions: [],
          budgets: [],
          goals: [],
          savings: [],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    if (isMobile(context)) {
      // Mobile View: Use InkWell with icon and text
      return InkWell(
        onTap: () {
          _showResetConfirmationDialog();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              size: 24,
              Icons.refresh,
              color: Theme.of(context).colorScheme.error,
            ),
            horizontalSpacer12,
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Reset',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Window View: Use DecoratedBox with TextButton
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.error),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextButton(
          onPressed: () {
            _showResetConfirmationDialog();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 15.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Reset',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      );
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }

    final List<String> words = text.split(' ');
    final List<String> capitalizedWords = words.map((String word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

  // void _showThemeSelector(BuildContext context) {
  //   // ignore: inference_failure_on_function_invocation
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true, // Allows control over the height
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16.0), // Rounded corners at the top
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.4, // Covers 30% of the screen height
  //         child: AppearancePage(
  //           _userProfile,
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildSettingsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: _colorScheme.primary,
                      child: Text(
                        _getInitials(),
                        style: _textTheme.titleSmall?.copyWith(
                          color: _colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      capitalizeFirstLetter(
                        widget.currentUserDetails.userProfile.firstName,
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                if (!isMobile(context))
                  SizedBox(
                    height: 40.0,
                    child: Row(
                      spacing: 16.0,
                      children: <Widget>[
                        ExportButton(
                          onTap: () {
                            handleOnTapExportLogic(context);
                          },
                        ),
                        _buildResetButton(context),
                      ],
                    ),
                  ),
              ],
            ),
            verticalSpacer16,
            Divider(
              height: 1,
              thickness: 1,
              color: _colorScheme.outlineVariant,
            ),
            verticalSpacer24,
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      pageNavigatorNotifier.value = NavigationPagesSlot.profile;
                    },
                    child: _buildSettingOptions(
                      'Profile',
                      _getSubTitleText(),
                      Icon(
                        const IconData(0xe726, fontFamily: fontIconFamily),
                        size: 24.0,
                        color: _colorScheme.onSurfaceVariant,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 24.0,
                        color: _colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  if (!isMobile(context))
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: _colorScheme.outlineVariant,
                    ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      pageNavigatorNotifier.value =
                          NavigationPagesSlot.personalization;
                    },
                    child: _buildSettingOptions(
                      'Personalization',
                      'Preferred Language, Currency, Time Zone',
                      Icon(
                        const IconData(0xe73d, fontFamily: fontIconFamily),
                        size: 24.0,
                        color: _colorScheme.onSurfaceVariant,
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 24.0,
                        color: _colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  if (!isMobile(context))
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: _colorScheme.outlineVariant,
                    ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      pageNavigatorNotifier.value =
                          NavigationPagesSlot.appearance;
                      // if (isMobile(context)) {
                      //   _showThemeSelector(context);
                      // } else {
                      //   pageNavigatorNotifier.value = NavigationPagesSlot.appearance;
                      // }
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: ValueListenableBuilder(
                      valueListenable: _isHovered,
                      builder:
                          (BuildContext context, bool value, Widget? child) {
                            return _buildSettingOptions(
                              'Appearance',
                              'Light and Dark themes',
                              Icon(
                                const IconData(
                                  0xe72c,
                                  fontFamily: fontIconFamily,
                                ),
                                size: 24.0,
                                color: _colorScheme.onSurfaceVariant,
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24.0,
                                color: _colorScheme.onPrimaryContainer,
                              ),
                            );
                          },
                    ),
                  ),
                  if (!isMobile(context))
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: _colorScheme.outlineVariant,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (isMobile(context)) Flexible(child: _buildResetButton(context)),
      ],
    );
  }

  String _getSubTitleText() {
    final Profile userProfile = widget.currentUserDetails.userProfile;
    final List<String> details = ['Name'];

    if (userProfile.dateOfBirth != null) {
      details.add('Date of Birth');
    }
    if (userProfile.gender != null) {
      details.add('Gender');
    }

    return details.join(', ');
  }

  Widget _buildSettingOptions(
    String text,
    String subtitle,
    Widget leading,
    Widget trailing,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 16.0,
        vertical: isMobile(context) ? 8.0 : 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (isMobile(context)) Center(child: leading),
          horizontalSpacer12,
          Expanded(
            child: Column(
              spacing: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  style: _textTheme.bodyLarge!.copyWith(
                    color: _colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: _textTheme.bodyMedium!.copyWith(
                    color: _colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpacer16,
          if (!isMobile(context))
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: trailing,
            ),
        ],
      ),
    );
  }
}
