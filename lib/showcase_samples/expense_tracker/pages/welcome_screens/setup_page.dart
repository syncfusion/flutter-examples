import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../meta_tag/meta_tag.dart';
import '../../constants.dart';
import '../../custom_widgets/custom_drop_down_menu.dart';
import '../../custom_widgets/single_selection_date_picker.dart';
import '../../custom_widgets/text_field.dart';
// import '../../data_processing/utils.dart';
import '../../enum.dart';
// import '../../helper/common_helper.dart';
// import '../../helper/common_helper.dart';
import '../../helper/currency_and_data_format/currency_format.dart';
import '../../helper/currency_and_data_format/date_format.dart';
import '../../helper/responsive_layout.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../notifiers/drawer_notifier.dart';
import '../../notifiers/import_notifier.dart';
import '../../notifiers/setup_notifier.dart';
import '../../notifiers/welcome_screen_notifier.dart';

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage(this.userDetails, this.pageController, {super.key});

  final PageController pageController;
  final UserDetails userDetails;

  @override
  SetupProfilePageState createState() => SetupProfilePageState();
}

class SetupProfilePageState extends State<SetupProfilePage> {
  String? _selectedGender;
  String? currencySelectedValue;
  String? genderSelectedValue;
  late final ValueNotifier<String> _selectedCurrencyNotifier;
  late final UserDetails _userDetails;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _datePickerController;
  late final ValueNotifier<String?> _firstNameErrorMessage;
  late final ValueNotifier<String?> _lastNameErrorMessage;
  late final TextEditingController _genderController;
  late final TextEditingController _currencyController;
  late final FocusNode _firstNameFocusNode;
  late final FocusNode _lastNameFocusNode;
  late final FocusNode _datePickerFocusNode;
  late final FocusNode _genderFocusNode;
  late final FocusNode _currencyFocusNode;
  late SetupNotifier _setupNotifier;
  late WelcomeScreenNotifier _pageNotifier;
  late ImportNotifier _importNotifier;
  DateTime? _selectedDate;
  final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

  /// Initializes all controllers, notifiers, and focus nodes.
  void _initializeFields() {
    _userDetails = widget.userDetails;
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _datePickerController = TextEditingController();
    _genderController = TextEditingController();
    _currencyController = TextEditingController();
    _firstNameErrorMessage = ValueNotifier<String?>(null);
    _lastNameErrorMessage = ValueNotifier<String?>(null);
    _selectedCurrencyNotifier = ValueNotifier<String>(
      _userDetails.userProfile.currency,
    );
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _datePickerFocusNode = FocusNode();
    _genderFocusNode = FocusNode();
    _currencyFocusNode = FocusNode();
  }

  /// Disposes controllers, focus nodes, and notifiers.
  void _disposeControllersAndFocusNodes() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _datePickerController.dispose();
    _currencyController.dispose();
    _firstNameErrorMessage.dispose();
    _lastNameErrorMessage.dispose();
    _selectedCurrencyNotifier.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _datePickerFocusNode.dispose();
    _currencyFocusNode.dispose();
    // widget.pageController.dispose();
    // _setupNotifier.dispose();
    // _pageNotifier.dispose();
  }

  /// Validates text fields and updates notifier state.
  void _validateAllFields(BuildContext context) {
    _validateField(
      _firstNameController,
      _firstNameErrorMessage,
      context,
      'First name cannot be empty',
    );
    _validateField(
      _lastNameController,
      _lastNameErrorMessage,
      context,
      'Last name cannot be empty',
    );
  }

  /// Checks if all fields are valid.
  bool _areFieldsValid() {
    return _firstNameErrorMessage.value == null &&
        _lastNameErrorMessage.value == null &&
        _selectedCurrencyNotifier.value.isNotEmpty;
  }

  /// Validates individual fields based on criteria.
  void _validateField(
    TextEditingController controller,
    ValueNotifier<String?> errorNotifier,
    BuildContext context,
    String emptyMessage,
  ) {
    if (controller.text.isEmpty) {
      errorNotifier.value = emptyMessage;
    } else {
      errorNotifier.value = null;
    }
  }

  /// Builds mobile layout for signup form.
  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(child: _buildDesktopLayout(context));
  }

  /// Builds desktop layout for signup form.
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!isMobile(context))
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 2,
            child: Image.asset(screenCoverAssetPath, fit: BoxFit.fill),
          ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(context);

                      // Sets default meta tag details when navigating from the
                      // sign-up page to the home page.
                      metaTagUpdate.setDefault();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Go to Sample Browser', // Updated text
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 420.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildSignUpForm(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds main signup form.
  Widget _buildSignUpForm(BuildContext context) {
    final List<String> currencies = buildCurrencies();
    final String selectedCurrency = _selectedCurrencyNotifier.value;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleText(context),
        verticalSpacer8,
        _buildIntroText(context),
        verticalSpacer32,
        _buildNameFields(context),
        verticalSpacer16,
        _buildDOBField(context),
        verticalSpacer16,
        _buildGenderDropdown(context),
        verticalSpacer16,
        _buildCurrencyDropdown(currencies, selectedCurrency),
        verticalSpacer16,
        _buildSetUpButton(context),
      ],
    );
  }

  /// Builds the title text for the page.
  Widget _buildTitleText(BuildContext context) {
    return Text(
      "Let's Set Up Your Account",
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  /// Builds introductory text to guide the user.
  Widget _buildIntroText(BuildContext context) {
    return Center(
      child: Text(
        'Complete your profile for personalized insights.',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Builds both first name and last name input fields.
  Widget _buildNameFields(BuildContext context) {
    return MediaQuery.of(context).size.width < 600.0
        ? Column(
            children: <Widget>[
              _buildFirstNameField(),
              verticalSpacer16,
              _buildLastNameField(),
            ],
          )
        : Row(
            children: <Widget>[
              Expanded(child: _buildFirstNameField()),
              horizontalSpacer16,
              Flexible(child: _buildLastNameField()),
            ],
          );
  }

  /// Builds first name text field.
  Widget _buildFirstNameField() {
    return ChangeNotifierProvider.value(
      value: _firstNameErrorMessage,
      child: Consumer<ValueNotifier<String?>>(
        builder:
            (
              BuildContext context,
              ValueNotifier<String?> notifier,
              Widget? child,
            ) {
              return CustomTextField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                hintText: 'First Name',
                errorMessage: notifier.value,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.allow(RegExp('[a-z A-z]')),
                ],
                onChanged: (String value) =>
                    _setupNotifier.validateNextButton(),
              );
            },
      ),
    );
  }

  /// Builds last name text field.
  Widget _buildLastNameField() {
    return ChangeNotifierProvider.value(
      value: _lastNameErrorMessage,
      child: Consumer<ValueNotifier<String?>>(
        builder:
            (
              BuildContext context,
              ValueNotifier<String?> notifier,
              Widget? child,
            ) {
              return CustomTextField(
                controller: _lastNameController,
                focusNode: _lastNameFocusNode,
                hintText: 'Last Name',
                errorMessage: notifier.value,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.allow(RegExp('[a-z A-z]')),
                ],
                onChanged: (String value) =>
                    _setupNotifier.validateNextButton(),
              );
            },
      ),
    );
  }

  /// Builds date of birth text field.
  Widget _buildDOBField(BuildContext context) {
    return CustomTextField(
      controller: _datePickerController,
      focusNode: _datePickerFocusNode,
      isRequired: false,
      hintText: 'Date Of Birth',
      suffixIcon: _buildDOBIcon(context),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
      ],
      onChanged: _onChanged,
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
          _datePickerController.text = selectedDate;
          _selectedDate = DateFormat(currentDateFormat).parse(selectedDate);
        },
        enablePastDates: true,
        maxDates: DateTime.now(),
        isSetupPage: true,
      );
    };
  }

  /// Handles logics while typing on the first & last names and dob text fields.
  void _onChanged(String value) => _setupNotifier.validateNextButton();

  /// Builds Gender selection dropdown.
  Widget _buildGenderDropdown(BuildContext context) {
    return CustomDropdown(
      expandedInsets: EdgeInsets.zero,
      items: const <String>['Male', 'Female', 'Others'],
      controller: _genderController,
      focusNode: _genderFocusNode,
      isRequired: false,
      hintText: 'Gender',
      initialValue: _selectedGender,
      onSelected: _genderOnSelected,
      selectedValue: genderSelectedValue,
    );
  }

  /// Handles logic while selecting the gender.
  void _genderOnSelected(String? newValue) {
    if (newValue != null) {
      setState(() {
        genderSelectedValue = newValue;
      });
      _selectedGender = newValue;
      _setupNotifier.validateNextButton();
    }
  }

  /// Builds Currency selection dropdown.
  Widget _buildCurrencyDropdown(
    List<String> currencies,
    String selectedCurrency,
  ) {
    return CustomDropdown(
      expandedInsets: EdgeInsets.zero,
      items: currencies,
      initialValue: '',
      controller: _currencyController,
      focusNode: _currencyFocusNode,
      hintText: 'Currency',
      onSelected: _currencyOnSelected,
      selectedValue: currencies[0],
    );
  }

  /// Handles logic while selecting the currency.
  void _currencyOnSelected(String? value) {
    if (value != null) {
      setState(() {
        currencySelectedValue = value;
      });

      _selectedCurrencyNotifier.value = value;
      _userDetails.userProfile.currency = value;
      _userDetails.userProfile.isSelectedCurrency = true;
      _setupNotifier.validateNextButton();
    }
  }

  Widget _buildSetUpButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSkipButton(context),
        const SizedBox(width: 1),
        _buildNextButton(context),
      ],
    );
  }

  /// Builds the setup button with functionality.
  Widget _buildNextButton(BuildContext context) {
    return Consumer<SetupNotifier>(
      builder:
          (BuildContext context, SetupNotifier setupNotifier, Widget? child) {
            final bool isEnabled = setupNotifier.enableNextButton(
              _firstNameController.text,
              _lastNameController.text,
              _currencyController.text,
            );
            return Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isEnabled
                    ? () => _onNextPressed(context, setupNotifier)
                    : null,
                style: isEnabled
                    ? null
                    : TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        overlayColor: Colors.transparent,
                      ),
                child: const Text('Next'),
              ),
            );
          },
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return Consumer<SetupNotifier>(
      builder:
          (BuildContext context, SetupNotifier setupNotifier, Widget? child) {
            return Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _onSkipPressed(context, setupNotifier);
                },
                child: const Text('Skip'),
              ),
            );
          },
    );
  }

  Future<void> _onSkipPressed(
    BuildContext context,
    SetupNotifier setupNotifier,
  ) async {
    _importNotifier.updateUserProfile(_setSkippedUserProfile());
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    _pageNotifier.currentPage = WelcomeScreens.importPage;
  }

  /// Handles action for the 'Next' button.
  Future<void> _onNextPressed(
    BuildContext context,
    SetupNotifier setupNotifier,
  ) async {
    _validateAllFields(context);
    if (_areFieldsValid()) {
      _importNotifier.updateUserProfile(_setUserProfile());
      // await updateUserProfile(context, userProfile, isNewUser: true);
      // final UserDetails userDetails = setDefaultUserDetails(userProfile);
      if (context.mounted) {
        // await writeTransactionalDetailsToFile(
        //   context,
        //   userDetails,
        //   UserInteractions.add,
        //   addedDateTime: null,
        //   isNewUser: true,
        // );
      }
      widget.pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _pageNotifier.currentPage = WelcomeScreens.importPage;
    }
  }

  Profile _setSkippedUserProfile() {
    return Profile(
      firstName: 'Guest',
      lastName: '',
      userId: 'Guest01',
      currency: 'Dollar',
      isSelectedCurrency: true,
      isDrawerExpanded: Provider.of<DrawerNotifier>(
        context,
        listen: false,
      ).isExpanded,
    );
  }

  Profile _setUserProfile() {
    return Profile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      gender: _selectedGender ?? '',
      userId: 'EAUser#00',
      dateOfBirth: _selectedDate,
      currency: _selectedCurrencyNotifier.value,
      isSelectedCurrency: true,
      isDrawerExpanded: Provider.of<DrawerNotifier>(
        context,
        listen: false,
      ).isExpanded,
    );
  }

  @override
  void initState() {
    _initializeFields();
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setupNotifier = Provider.of<SetupNotifier>(context, listen: false);
    _pageNotifier = Provider.of<WelcomeScreenNotifier>(context, listen: false);
    _importNotifier = Provider.of<ImportNotifier>(context, listen: false);

    if (_pageNotifier.currentPage == WelcomeScreens.setupPage) {
      // Updates meta tag details when navigating from the home page to the
      // expense tracker setup (sign-up) page.
      metaTagUpdate.update('Setup', 'Expense Tracker');
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _disposeControllersAndFocusNodes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: isMobile(context)
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }
}
