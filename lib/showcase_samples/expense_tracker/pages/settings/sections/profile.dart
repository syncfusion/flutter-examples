import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../custom_widgets/single_selection_date_picker.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/user_profile.dart';
import '../../base_home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this.userProfile, {super.key});

  final Profile userProfile;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateController;
  String _selectedGender = 'Male';
  bool _isChanged = false;

  late String _originalFirstName;
  late String _originalLastName;
  late String _originalDate;
  late String _originalGender;

  late TextTheme _textTheme;
  late ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    _originalFirstName = widget.userProfile.firstName;
    _originalLastName = widget.userProfile.lastName;
    _originalDate = widget.userProfile.dateOfBirth != null
        ? DateFormat('MM/dd/yyyy').format(widget.userProfile.dateOfBirth!)
        : '';
    _originalGender = widget.userProfile.gender ?? '';

    _firstNameController = TextEditingController(text: _originalFirstName);
    _lastNameController = TextEditingController(text: _originalLastName);
    _dateController = TextEditingController(text: _originalDate);
    _selectedGender = _originalGender;

    _firstNameController.addListener(_checkIfChanged);
    _lastNameController.addListener(_checkIfChanged);
    _dateController.addListener(_checkIfChanged);
  }

  void _checkIfChanged() {
    setState(() {
      _isChanged =
          _firstNameController.text != _originalFirstName ||
          _lastNameController.text != _originalLastName ||
          _dateController.text != _originalDate ||
          _selectedGender != _originalGender;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Widget _buildNameFields(BuildContext context) {
    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: _textTheme.bodyLarge!.copyWith(
              color: _colorScheme.onSurface,
            ),
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          verticalSpacer24,
          if (_lastNameController.text.isNotEmpty)
            TextField(
              style: _textTheme.bodyLarge!.copyWith(
                color: _colorScheme.onSurface,
              ),
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              style: _textTheme.bodyLarge!.copyWith(
                color: _colorScheme.onSurface,
              ),
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          horizontalSpacer16,
          if (_lastNameController.text.isNotEmpty)
            Expanded(
              child: TextField(
                style: _textTheme.bodyLarge!.copyWith(
                  color: _colorScheme.onSurface,
                ),
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _textTheme = Theme.of(context).textTheme;
    _colorScheme = Theme.of(context).colorScheme;

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

  /// Builds suffix icon for date of birth field.
  Widget _buildDOBIcon(BuildContext context) {
    return IconButton(
      icon: Icon(
        const IconData(0xe72b, fontFamily: fontIconFamily),
        size: 24.0,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onPressed: _dobOnPressed(),
    );
  }

  /// Handles action while tapping on the date picker icon in dob text field.
  void Function()? _dobOnPressed() {
    return () {
      showSingleDatePickerDialog(
        context,
        onSingleDateSelected: (String selectedDate) {
          setState(() {
            _dateController.text = selectedDate;
            _checkIfChanged();
          });
        },
        enablePastDates: true,
        maxDates: DateTime.now(),
        isSetupPage: true,
      );
    };
  }

  Column _buildSettingsFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SizedBox(
            width: isMobile(context)
                ? MediaQuery.of(context).size.width
                : 620.0,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameFields(context),
                verticalSpacer32,
                if (_originalDate != '')
                  TextField(
                    style: _textTheme.bodyLarge!.copyWith(
                      color: _colorScheme.onSurface,
                    ),
                    controller: _dateController,
                    readOnly: true,
                    canRequestFocus: false,
                    cursorColor: Colors.transparent,
                    showCursor: false,
                    mouseCursor: MouseCursor.uncontrolled,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: _buildDOBIcon(context),
                    ),
                  ),
                verticalSpacer32,
                if (_originalGender != '')
                  DropdownMenu<String>(
                    width: isMobile(context)
                        ? MediaQuery.of(context).size.width
                        : 620.0,
                    initialSelection: _selectedGender,
                    label: const Text('Gender'),
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onSelected: (String? value) {
                      setState(() {
                        if (value != null) {
                          _selectedGender = value;
                          _checkIfChanged();
                        }
                      });
                    },
                    dropdownMenuEntries: <String>['Male', 'Female', 'Other']
                        .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                            value: value,
                            label: value,
                          );
                        })
                        .toList(),
                    textStyle: _textTheme.bodyLarge!.copyWith(
                      color: _colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              height: 1,
              thickness: 1,
              color: _colorScheme.outlineVariant,
            ),
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
                    border: Border.all(color: _colorScheme.outline),
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
                      onPressed: () {
                        pageNavigatorNotifier.value =
                            NavigationPagesSlot.settings;
                      },
                      style: TextButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      child: Text(
                        'Discard',
                        style: _textTheme.titleSmall?.copyWith(
                          color: _colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                horizontalSpacer14,
                Container(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _isChanged
                        ? _colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: _isChanged
                          ? Colors.transparent
                          : _colorScheme.outline,
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
                      onPressed: _isChanged
                          ? () {
                              widget.userProfile.firstName =
                                  _firstNameController.text;
                              widget.userProfile.lastName =
                                  _lastNameController.text;
                              widget.userProfile.gender = _selectedGender;
                              widget.userProfile.dateOfBirth = DateFormat(
                                'MM/dd/yyyy',
                              ).parse(_dateController.text);

                              pageNavigatorNotifier.value =
                                  NavigationPagesSlot.settings;
                            }
                          : null,
                      style: TextButton.styleFrom(
                        disabledForegroundColor: _colorScheme.onSurface,
                      ),
                      child: Text(
                        'Update',
                        style: _textTheme.titleSmall?.copyWith(
                          color: _isChanged
                              ? _colorScheme.onPrimary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
