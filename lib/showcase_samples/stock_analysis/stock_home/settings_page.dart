import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum.dart';
import '../helper/editable_text_field.dart';
import '../helper/helper.dart';
import '../helper/responsive_layout.dart';
import '../model/user_detail.dart';
import '../notifier/stock_chart_notifier.dart';
import '../notifier/theme_notifier.dart';
import 'stock_chart_view/profile_menu_popup.dart';

class StockProfileSettingsPage extends StatefulWidget {
  const StockProfileSettingsPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.firstNameFirstLetter,
    required this.lastNameFirstLetter,
  });

  final String firstName;
  final String lastName;
  final String firstNameFirstLetter;
  final String lastNameFirstLetter;

  @override
  State<StockProfileSettingsPage> createState() =>
      _StockProfileSettingsPageState();
}

class _StockProfileSettingsPageState extends State<StockProfileSettingsPage> {
  BoxShadow _boxShadow(
    double blurRadius,
    Color color, [
    double spreadRadius = 1.0,
  ]) {
    return BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Selector<StockChartProvider, UserDetail>(
      selector: (BuildContext context, StockChartProvider provider) =>
          provider.user,
      builder: (BuildContext context, UserDetail user, Widget? child) {
        return Scaffold(
          backgroundColor: themeData.colorScheme.surfaceContainerLow,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              shadowColor: const Color(0xff000026),
              surfaceTintColor: Colors.transparent,
              leadingWidth: 0.0,
              titleSpacing: 0.0,
              title: _buildDefaultAppBar(context, user),
              backgroundColor: themeData.colorScheme.surface,
              elevation: 2.0,
            ),
          ),
          body: _buildSettingsPage(),
        );
      },
    );
  }

  EdgeInsets _getPadding() {
    return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);
  }

  /// Creates a box shadow with specified parameters.
  BoxShadow _getBoxShadow(
    double blurRadius,
    Color color, [
    double spreadRadius = 1.0,
  ]) {
    return BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      color: color,
    );
  }

  Widget _buildDefaultAppBar(BuildContext context, UserDetail user) {
    final ThemeData themeData = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        boxShadow: [
          _getBoxShadow(3.0, const Color(0xff000026)),
          _getBoxShadow(2.0, const Color(0xff00004D), 0.0),
        ],
      ),
      child: Padding(
        padding: _getPadding(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    IconData(0xe709, fontFamily: stockFontIconFamily),
                  ),
                  onPressed: () {
                    context.read<StockChartProvider>()
                      ..isEditableTextMap['First'] = false
                      ..isEditableTextMap['Last'] = false;
                    Navigator.of(context).pop();
                  },
                ),
                const Text('Stock Chart'),
              ],
            ),

            ProfileMenuPopup(
              user.firstName[0].capitalizeFirst(),
              user.lastName.isEmpty ? '' : user.lastName[0].capitalizeFirst(),
              user.firstName,
              user.lastName,
              themeData,
              onChanged: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return deviceType(context) == DeviceType.desktop
        ? _buildSettingsDesktopView()
        : _buildSettingsMobileView();
  }

  Widget _buildSettingsDesktopView() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBasicInfoSection(context),
              const SizedBox(height: 16),
              _buildAppearanceSection(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsMobileView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildBasicInfoSection(context),
          const SizedBox(height: 16),
          _buildAppearanceSection(context),
          const SizedBox(height: 24),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Info',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildAvatarInfo(context),
            _buildNameInfo(context, 'First Name', widget.firstName),
            if (widget.lastName.isNotEmpty)
              _buildNameInfo(
                context,
                'Last Name',
                widget.lastName,
                isFirstName: false,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarInfo(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final UserDetail user = context.read<StockChartProvider>().user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile Picture',
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.colorScheme.onSurface,
              fontWeight: fontWeight400(),
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: themeData.colorScheme.primaryContainer,
            child: Text(
              user.firstName[0].capitalizeFirst() +
                  (user.lastName.isEmpty
                      ? ''
                      : user.lastName[0].capitalizeFirst()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInfo(
    BuildContext context,
    String label,
    String initialValue, {
    bool isFirstName = true,
  }) {
    return NameTextField(
      label: label,
      initialValue: initialValue,
      isFirstName: isFirstName,
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: fontWeight400(),
                  ),
                ),
                const ThemeModePopup(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Align(
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            _boxShadow(3.0, const Color.fromRGBO(0, 0, 0, 0.15)),
            _boxShadow(2.0, const Color.fromRGBO(0, 0, 0, 0.3), 0),
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            context.read<StockChartProvider>().resetData();
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/stock-chart',
              ModalRoute.withName('/'),
            );
          },
          child: Text(
            'Log out',
            style: themeData.textTheme.titleSmall?.copyWith(
              color: themeData.colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeModePopup extends StatelessWidget {
  const ThemeModePopup({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 90,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.outline),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Selector<StockThemeNotifier, ThemeMode>(
        selector: (BuildContext context, StockThemeNotifier provider) =>
            provider.themeMode,
        builder: (BuildContext context, ThemeMode themeMode, Widget? child) {
          return PopupMenuButton<ThemeMode>(
            position: PopupMenuPosition.under,
            padding: EdgeInsets.zero,
            onSelected: (ThemeMode mode) {
              context.read<StockThemeNotifier>().themeMode = mode;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('Light'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('Dark'),
              ),
              const PopupMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('System'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    themeMode.name.capitalizeFirst(),
                    style: themeData.textTheme.labelLarge?.copyWith(
                      color: themeData.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    const IconData(0xe704, fontFamily: stockFontIconFamily),
                    size: 12,
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
