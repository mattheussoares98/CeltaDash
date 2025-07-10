import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/helpers.dart';

// A placeholder for your app's constants, like store URLs.
// Replace these with your actual App Store and Play Store links.
class AppConstants {
  static const String appStoreUrl = 'https://apps.apple.com/app/id6745738261';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=br.com.celtaware.dash';
}

/// A screen that informs the user that an update is required and blocks app usage.
class UpdateAppVersionPage extends StatelessWidget {
  const UpdateAppVersionPage({super.key});

  // Function to launch the appropriate store URL.
  // It now accepts BuildContext to determine the platform (iOS/Android).
  void _launchStore(BuildContext context) {
    final url = Uri.parse(
      Theme.of(context).platform != TargetPlatform.android
          ? AppConstants.playStoreUrl
          : AppConstants.appStoreUrl,
    );
    // The mode makes it open the store outside of your app.
    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Icon
              Icon(
                Icons.system_update_rounded,
                size: 120,
                color: theme.primaryColor,
              ),
              const SizedBox(height: 32),

              // 2. Title
              Text(
                R.string.msgNewAppRequiredVersion,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Message
              Text(
                R.string.msgNewUpdateDescription,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),

              // 4. Animated Update Button
              // The context from the build method is passed to the launch function.
              AnimatedUpdateButton(onPressed: () => _launchStore(context)),
            ],
          ),
        ),
      ),
    );
  }
}

/// An animated button that pulses to draw user attention.
class AnimatedUpdateButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedUpdateButton({super.key, required this.onPressed});

  @override
  State<AnimatedUpdateButton> createState() => _AnimatedUpdateButtonState();
}

class _AnimatedUpdateButtonState extends State<AnimatedUpdateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Create a pulsating (breathing) effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Make the animation loop back and forth
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download_rounded),
        label: Text(R.string.update),
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: theme.primaryColor.withAlpha(100),
        ),
      ),
    );
  }
}
