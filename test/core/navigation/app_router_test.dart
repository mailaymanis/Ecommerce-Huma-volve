import 'package:ecommerce_app_huma_volve/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRouter.onGenerateRoute', () {
    test('builds the product details page for a product link', () {
      final route = AppRouter.onGenerateRoute(
        const RouteSettings(name: '/product/12'),
      );

      expect(route, isA<PageRouteBuilder<dynamic>>());
      expect(route.settings.name, '/product/12');
    });

    test('builds the product details page for a cold start link', () {
      final route = AppRouter.onGenerateRoute(
        const RouteSettings(name: 'ecommerce://shop.huma-volve.com/product/5'),
      );

      expect(route.settings.name, 'ecommerce://shop.huma-volve.com/product/5');
    });

    test('falls back to a page for an unknown link instead of null', () {
      // A null route would make Navigator throw while handling the intent.
      expect(
        AppRouter.onGenerateRoute(const RouteSettings(name: '/unknown')),
        isNotNull,
      );
    });
  });
}
