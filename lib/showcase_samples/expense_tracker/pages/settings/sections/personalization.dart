import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../custom_widgets/text_field.dart';
// import '../../../data_processing/utils.dart';
import '../../../helper/currency_and_data_format/date_format.dart';
import '../../../helper/dashboard.dart';
import '../../../helper/responsive_layout.dart';
import '../../../models/user_profile.dart';
import '../../base_home.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage(this.userProfile, {super.key});

  final Profile userProfile;

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage> {
  late TextTheme _textTheme;
  late ColorScheme _colorScheme;
  late String _selectedCurrency;
  late String _selectedDateFormat;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.userProfile.currency;
    _selectedDateFormat = widget.userProfile.dateFormat;
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

  Column _buildSettingsFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrencyDisplay(),
            verticalSpacer32,
            _buildDateFormatDropdown(),
          ],
        ),
        const Spacer(),
        Divider(color: _colorScheme.outlineVariant),
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
                  onPressed: () => pageNavigatorNotifier.value =
                      NavigationPagesSlot.settings,
                  style: TextButton.styleFrom(overlayColor: Colors.transparent),
                  child: const Text('Discard'),
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
                color: _hasChanges ? _colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: _hasChanges
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
                  style: TextButton.styleFrom(
                    disabledForegroundColor: _colorScheme.onSurface,
                  ),
                  onPressed: _hasChanges
                      ? () {
                          widget.userProfile.currency = _selectedCurrency;
                          widget.userProfile.dateFormat = _selectedDateFormat;
                          // updateUserProfile(context, widget.userProfile);
                          pageNavigatorNotifier.value =
                              NavigationPagesSlot.settings;
                        }
                      : null,
                  child: Text(
                    'Update',
                    style: _textTheme.titleSmall?.copyWith(
                      color: _hasChanges ? _colorScheme.onPrimary : Colors.grey,
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

  final Map<String, Map<String, String>>
  currencyMap = <String, Map<String, String>>{
    'US': <String, String>{'currency': 'United States Dollar', 'symbol': r'$'},
    'Canada': <String, String>{'currency': 'Canadian Dollar', 'symbol': r'CA$'},
    'United Kingdom': <String, String>{
      'currency': 'British Pound',
      'symbol': '£',
    },
    'Germany': <String, String>{'currency': 'Euro', 'symbol': '€'},
    'France': <String, String>{'currency': 'Euro', 'symbol': '€'},
    'Italy': <String, String>{'currency': 'Euro', 'symbol': '€'},
    'Spain': <String, String>{'currency': 'Euro', 'symbol': '€'},
    'Japan': <String, String>{'currency': 'Japanese Yen', 'symbol': '¥'},
    'Australia': <String, String>{
      'currency': 'Australian Dollar',
      'symbol': r'$',
    },
    'Brazil': <String, String>{'currency': 'Brazilian Real', 'symbol': r'R$'},
    'Mexico': <String, String>{'currency': 'Mexican Peso', 'symbol': r'$'},
    'India': <String, String>{'currency': 'Indian Rupee', 'symbol': '₹'},
    'China': <String, String>{'currency': 'Chinese Yuan', 'symbol': '¥'},
    'South Africa': <String, String>{
      'currency': 'South African Rand',
      'symbol': 'R',
    },
    'Russia': <String, String>{'currency': 'Russian Ruble', 'symbol': '₽'},
    'Singapore': <String, String>{
      'currency': 'Singapore Dollar',
      'symbol': r'S$',
    },
  };

  Widget _buildCurrencyDisplay() {
    String currencySymbol = _selectedCurrency;

    for (final entry in currencyMap.entries) {
      if (entry.value['symbol'] == _selectedCurrency) {
        currencySymbol = entry.value['symbol']!;
        break;
      }
    }

    return SizedBox(
      width: isMobile(context) ? MediaQuery.of(context).size.width : 620.0,
      child: CustomTextField(
        keyboardType: TextInputType.none,
        enabled: false,
        mouseCursor: MouseCursor.uncontrolled,
        enableInteractiveSelection: false,
        isRequired: false,
        controller: TextEditingController(text: currencySymbol),
        focusNode: FocusNode(),
        hintText: 'Currency',
        showCursor: false,
        cursorColor: Colors.transparent,
        canRequestFocus: false,
      ),
    );

    // return DropdownMenu<String>(
    //   initialSelection: currencySymbol,
    //   enabled: false,
    //   width: isMobile(context) ? MediaQuery.of(context).size.width : 620.0,
    //   // label: const Text('Currency'),
    //   requestFocusOnTap: false,
    //   inputFormatters: const [],
    //   keyboardType: TextInputType.none,
    //   textStyle: _textTheme.bodyLarge?.copyWith(color: _colorScheme.onSurface),
    //   inputDecorationTheme: InputDecorationTheme(
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    //   ),
    //   dropdownMenuEntries: [
    //     DropdownMenuEntry<String>(
    //       value: currencySymbol,
    //       label: currencySymbol,
    //     ),
    //   ],
    //   onSelected: (String? value) {},
    // );
  }

  Widget _buildDateFormatDropdown() {
    return DropdownMenu<String>(
      initialSelection: _selectedDateFormat,
      width: isMobile(context) ? MediaQuery.of(context).size.width : 620.0,
      label: const Text('Date Format'),
      textStyle: _textTheme.bodyLarge?.copyWith(color: _colorScheme.onSurface),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      dropdownMenuEntries: List.generate(dateFormats.length, (int index) {
        final String key = dateFormats.keys.elementAt(index);
        final String value = dateFormats[key]!;
        return DropdownMenuEntry<String>(value: key, label: value);
      }),
      onSelected: (String? value) {
        if (value != null && value != _selectedDateFormat) {
          setState(() {
            _selectedDateFormat = value;
            _hasChanges = true;
          });
        }
      },
    );
  }
}
