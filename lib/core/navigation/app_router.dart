import 'package:ecommerce_app_huma_volve/core/navigation/deep_link.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

/// Builds pages for named routes, including the ones the platform pushes when
/// a deep link opens the app.
///
/// The app navigates with `Navigator`, so this generator is the single place
/// that knows how an incoming link maps to a screen.
class AppRouter {
  const AppRouter._();

  /// Used by [MaterialApp.onGenerateRoute].
  ///
  /// Never returns `null`: an unknown link must still land on a page, otherwise
  /// `Navigator` throws while handling the intent.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final target = DeepLinkParser.parse(settings.name);

    switch (target) {
      case ProductDetailsTarget(:final productId):
        return _fadeRoute(
          settings: settings,
          builder: (context) =>
              ProductDetailsScreen.fromLink(productId: productId),
        );
      case null:
        // Unknown or malformed link: restart the regular flow instead of
        // leaving the user on an empty route.
        return _fadeRoute(
          settings: settings,
          builder: (context) => const SplashScreen(),
        );
    }
  }

  /// Leaves a details page opened from a link.
  ///
  /// A cold start link is the only route in the stack, so popping would leave
  /// the app empty; in that case the regular entry point is restored.
  static void back(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    navigator.pushReplacement(
      _fadeRoute(
        settings: const RouteSettings(name: Navigator.defaultRouteName),
        builder: (context) => const SplashScreen(),
      ),
    );
  }

  static Route<dynamic> _fadeRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
