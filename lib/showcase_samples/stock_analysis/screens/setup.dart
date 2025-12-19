// Stock Setup Module
// Handles initial user setup and profile creation
// Provides a responsive form layout for mobile and desktop

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../meta_tag/meta_tag.dart';
import '../enum.dart';
import '../helper/helper.dart';
import '../helper/responsive_layout.dart';
import '../model/user_detail.dart';
import '../notifier/stock_chart_notifier.dart';
import '../notifier/theme_notifier.dart';
import '../stock_home/home.dart';
import '../theme.dart';
import 'splash.dart';

/// Main entry point for starting the stock analysis application.
class StockAnalysis extends StatelessWidget {
  const StockAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<StockThemeNotifier, ThemeMode>(
      selector: (BuildContext context, StockThemeNotifier provider) =>
          provider.themeMode,
      builder: (BuildContext context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          initialRoute: '/stock-chart',
          routes: {
            '/stock-chart': (context) {
              return const SplashScreen(nextScreen: SetupProfilePage());
            },
          },
          darkTheme: darkTheme(),
          theme: lightTheme(),
        );
      },
    );
  }
}

/// Setup page for new user profiles, allowing for detailed user input.
class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  SetupProfilePageState createState() => SetupProfilePageState();
}

class SetupProfilePageState extends State<SetupProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

  @override
  void initState() {
    _initializeFields();
    super.initState();
  }

  @override
  void dispose() {
    _disposeControllersAndFocusNodes();
    super.dispose();
  }

  /// Initializes text controllers for user input fields.
  void _initializeFields() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  /// Disposes controllers to free up resources.
  void _disposeControllersAndFocusNodes() {
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  /// Validates user input fields.
  bool _isValid() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty;
  }

  /// Navigates to the home screen after setup completion.
  Future<void> _navigateToHomeScreen(BuildContext context) async {
    final StockChartProvider stockProvider = Provider.of<StockChartProvider>(
      context,
      listen: false,
    );
    await stockProvider.loadAllStocks();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => StockHomeScreen(
            firstName: _firstNameController.text.isEmpty
                ? 'Guest'
                : _firstNameController.text,
            lastName: _lastNameController.text,
            defaultStocks: stockProvider.stockData,
          ),
        ),
      );
    }
  }

  /// Builds the main setup page based on the device type.
  Widget _buildSetupPage(BuildContext context) {
    switch (deviceType(context)) {
      case DeviceType.mobile:
        return _buildMobileLayout(context);
      case DeviceType.desktop:
        return _buildDesktopLayout(context);
    }
  }

  /// Builds the mobile layout for the signup form.
  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 16.0,
            left: 16.0, // Changed from right to left
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
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    const IconData(0xe709, fontFamily: stockFontIconFamily),
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Go to Sample Browser', // Updated text
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 300.0, child: _buildSignUpForm(context)),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the desktop layout for the signup form.
  Widget _buildDesktopLayout(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Row(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 2.0,
          child: Image.asset(
            'assets/stock_logo/cover_image.png',
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(color: themeData.colorScheme.surface),
            child: Stack(
              children: [_buildBackButton(context), _buildCenterForm(context)],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the back button for navigation.
  Widget _buildBackButton(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Positioned(
      top: 16.0,
      left: 16.0,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: themeData.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              const IconData(0xe709, fontFamily: stockFontIconFamily),
              size: 20.0,
              color: themeData.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8.0),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                'Go to Sample Browser',
                style: TextStyle(
                  fontSize: 16.0,
                  color: themeData.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the center form for user input.
  Widget _buildCenterForm(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 420.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildSignUpForm(context),
          ),
        ),
      ),
    );
  }

  /// Builds the main signup form.
  Widget _buildSignUpForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTitleText(context),
        const SizedBox(height: 12.0),
        _buildIntroText(context),
        const SizedBox(height: 34.0),
        _buildNameFields(context),
        const SizedBox(height: 24.0),
        _buildSetUpButton(context),
      ],
    );
  }

  /// Builds the title text for the page.
  Widget _buildTitleText(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Text(
      "Let's Set Up Your Account",
      style: themeData.textTheme.titleLarge?.copyWith(
        color: themeData.colorScheme.onSurface,
      ),
    );
  }

  /// Builds introductory text to guide the user.
  Widget _buildIntroText(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Center(
      child: Text(
        'Complete your profile for personalized insights.',
        style: themeData.textTheme.bodyLarge!.copyWith(
          color: themeData.colorScheme.onSurfaceVariant,
          fontWeight: fontWeight400(),
        ),
      ),
    );
  }

  /// Builds both first name and last name input fields.
  Widget _buildNameFields(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildFirstNameField(),
        const SizedBox(height: 24.0),
        _buildLastNameField(),
      ],
    );
  }

  /// Builds first name text field.
  Widget _buildFirstNameField() {
    return _buildNameField(
      context: context,
      controller: _firstNameController,
      label: 'First Name',
    );
  }

  /// Builds last name text field.
  Widget _buildLastNameField() {
    return _buildNameField(
      context: context,
      controller: _lastNameController,
      label: 'Last Name',
    );
  }

  /// Builds a generic name input field with given parameters.
  Widget _buildNameField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    final ThemeData themeData = Theme.of(context);

    return TextField(
      controller: controller,
      selectionControls: MaterialTextSelectionControls(),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      ],
      onChanged: (String value) {
        if (_isValid()) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        hintText: label,
        hintStyle: themeData.textTheme.bodyLarge?.copyWith(
          color: themeData.colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: themeData.colorScheme.outline),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: themeData.colorScheme.error),
        ),
      ),
    );
  }

  /// Builds the setup button with functionality.
  Widget _buildSetUpButton(BuildContext context) {
    final bool isValid = _isValid();
    final ThemeData themeData = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(elevation: 2.0),
            onPressed: () async {
              context.read<StockChartProvider>().isLoading = true;
              try {
                await _navigateToHomeScreen(context);
              } catch (e) {
                if (context.mounted) {
                  final snackBar = SnackBar(
                    content: Text('Error loading stocks: $e'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } finally {
                if (context.mounted) {
                  context.read<StockChartProvider>().isLoading = false;
                }
              }

              // Updates meta tag details when navigating from the setup page
              // to the Stock Chart page in Stock Analysis.
              metaTagUpdate.update('Stock Chart', 'Stock Analysis');
            },
            child: const Text('Skip', textAlign: TextAlign.left),
          ),
          TextButton(
            onPressed: isValid
                ? () async {
                    context.read<StockChartProvider>().user = UserDetail(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                    );
                    context.read<StockChartProvider>().isLoading = true;
                    try {
                      await _navigateToHomeScreen(context);
                    } catch (e) {
                      if (context.mounted) {
                        final snackBar = SnackBar(
                          content: Text('Error loading stocks: $e'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } finally {
                      if (context.mounted) {
                        context.read<StockChartProvider>().isLoading = false;
                      }
                    }

                    // Updates meta tag details when navigating from the
                    // setup page to the Stock Chart page in Stock Analysis.
                    metaTagUpdate.update('Stock Chart', 'Stock Analysis');
                  }
                : null,
            child: Text(
              'Finish',
              textAlign: TextAlign.right,
              style: themeData.textTheme.labelLarge?.copyWith(
                color: isValid
                    ? themeData.colorScheme.primary
                    : themeData.colorScheme.outlineVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          _buildSetupPage(context),
          Selector<StockChartProvider, bool>(
            selector: (BuildContext context, StockChartProvider provider) =>
                provider.isLoading,
            builder: (BuildContext context, bool isLoading, Widget? child) =>
                isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
