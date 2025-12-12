import 'package:flutter/material.dart';

import '../../../../meta_tag/meta_tag.dart';
import '../../helper/helper.dart';
import '../settings_page.dart';

final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

class ProfileMenuPopup extends StatelessWidget {
  const ProfileMenuPopup(
    this.firstNameFirstLetter,
    this.lastNameFirstLetter,
    this.firstName,
    this.lastName,
    this.themeData, {
    this.onChanged,
  });
  final String firstNameFirstLetter;
  final String lastNameFirstLetter;
  final String firstName;
  final String lastName;
  final ThemeData themeData;
  final Function()? onChanged;

  List<PopupMenuEntry<String>> _buildProfileMenuItems(
    BuildContext context,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    String firstName,
    String lastName,
  ) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        enabled: false,
        value: 'profile',
        mouseCursor: SystemMouseCursors.basic,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                child: Text('$firstNameFirstLetter$lastNameFirstLetter'),
              ),
              const SizedBox(width: 12.0),
              Text(
                '$firstName $lastName',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: themeData.colorScheme.onSurface,
                  fontWeight: fontWeight500(),
                ),
              ),
            ],
          ),
        ),
      ),
      PopupMenuItem<String>(
        enabled: false,
        value: 'View Profile & Settings',
        mouseCursor: SystemMouseCursors.basic,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextButton(
            onPressed:
                onChanged ??
                () => _navigateToSettings(
                  context,
                  firstName,
                  lastName,
                  firstNameFirstLetter,
                  lastNameFirstLetter,
                ),
            style: TextButton.styleFrom(elevation: 1.0),
            child: Text(
              'View Profile & Settings',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: themeData.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      const PopupMenuDivider(height: 0.5),
      PopupMenuItem<String>(
        value: 'sample_browser',
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop(context);

          // Reset meta tags to default when navigating from Stock Analyst
          // page to Home page.
          metaTagUpdate.setDefault();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            spacing: 3,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.arrow_back,
                size: 20,
                color: themeData.colorScheme.primary,
              ),
              Text(
                'Go to Sample Browser',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: themeData.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  /// Navigates to the settings page.
  void _navigateToSettings(
    BuildContext context,
    String firstName,
    String lastName,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
  ) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return StockProfileSettingsPage(
            firstName: firstName,
            lastName: lastName,
            firstNameFirstLetter: firstNameFirstLetter,
            lastNameFirstLetter: lastNameFirstLetter,
          );
        },
      ),
    );
  }

  /// Builds the profile menu dropdown.
  Widget _buildProfileMenu(
    BuildContext context,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    String firstName,
    String lastName,
  ) {
    final GlobalKey<PopupMenuButtonState<String>> profilePopupMenuKey =
        GlobalKey<PopupMenuButtonState<String>>();

    return Theme(
      data: themeData.copyWith(splashFactory: NoSplash.splashFactory),
      child: PopupMenuButton<String>(
        key: profilePopupMenuKey,
        constraints: const BoxConstraints(minWidth: 300.0),
        padding: const EdgeInsets.only(top: 20.0),
        offset: const Offset(0, 4.0),
        elevation: 8.0,
        splashRadius: 0,
        shadowColor: Colors.black54,
        position: PopupMenuPosition.under,
        color: themeData.colorScheme.surface,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        tooltip: '',
        useRootNavigator: true,
        itemBuilder: (BuildContext context) {
          return _buildProfileMenuItems(
            context,
            firstNameFirstLetter,
            lastNameFirstLetter,
            firstName,
            lastName,
          );
        },
        child: _buildProfileMenuButton(
          context,
          firstName,
          lastName,
          firstNameFirstLetter,
          lastNameFirstLetter,
          profilePopupMenuKey,
        ),
      ),
    );
  }

  /// Builds the profile menu button with tooltip.
  Widget _buildProfileMenuButton(
    BuildContext context,
    String firstName,
    String lastName,
    String firstNameFirstLetter,
    String lastNameFirstLetter,
    GlobalKey<PopupMenuButtonState<String>> profilePopupMenuKey,
  ) {
    return Tooltip(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      message: '$firstName $lastName',
      textAlign: TextAlign.center,
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: themeData.colorScheme.onInverseSurface,
      ),
      child: GestureDetector(
        onTap: () {
          profilePopupMenuKey.currentState?.showButtonMenu();
        },
        child: CircleAvatar(
          radius: 20.0,
          child: Text('$firstNameFirstLetter$lastNameFirstLetter'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProfileMenu(
      context,
      firstNameFirstLetter,
      lastNameFirstLetter,
      firstName,
      lastName,
    );
  }
}
