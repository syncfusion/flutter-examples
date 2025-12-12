import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../meta_tag/meta_tag.dart';

/// A widget that displays a splash screen with animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.nextScreen, super.key});

  /// The next screen to navigate to after the splash screen.
  final Widget nextScreen;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controller for managing animation.
  late final AnimationController _animationController;

  /// Animation for fading effect.
  late final Animation<double> _fadeAnimation;
  final WebMetaTagUpdate metaTagUpdate = WebMetaTagUpdate();

  /// Initializes animations for the splash screen.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
  }

  /// Starts a timer to navigate to the next screen after delay.
  Future<void> _startNavigationTimer() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (mounted) {
      _navigateToNextScreen();
    }
  }

  /// Navigates to the provided next screen with a fade transition.
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder<Widget>(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget.nextScreen;
            },
        transitionsBuilder: _buildFadeTransition,
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Builds the fade transition for navigation.
  Widget _buildFadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  /// Builds the main content of the splash screen.
  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const ApplicationLogo(),
        Center(
          child: Text(
            'Stock Analysis',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startNavigationTimer();

    // Updates meta tag details when navigating from the home page to the
    // setup page in Stock Analysis.
    metaTagUpdate.update('Setup page', 'Stock Analysis');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildContent(context),
        ),
      ),
    );
  }
}

/// A widget that represents the application logo.
class ApplicationLogo extends StatelessWidget {
  const ApplicationLogo({super.key, this.iconWidth = 70});

  // The width of the logo icon.
  final double iconWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 250,
        child: SvgPicture.asset(
          'assets/stock_logo/app_logo.svg',
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
