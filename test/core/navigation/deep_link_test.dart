import 'package:ecommerce_app_huma_volve/core/navigation/deep_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeepLinkParser.parse', () {
    test('reads the product id from a cold start custom scheme link', () {
      expect(
        DeepLinkParser.parse('ecommerce://shop.huma-volve.com/product/12'),
        const ProductDetailsTarget(12),
      );
    });

    test('reads the product id from a short custom scheme link', () {
      // `product` is the host here, `12` the only path segment.
      expect(
        DeepLinkParser.parse('ecommerce://product/7'),
        const ProductDetailsTarget(7),
      );
    });

    test('reads the product id from a web link', () {
      expect(
        DeepLinkParser.parse('https://shop.huma-volve.com/product/31'),
        const ProductDetailsTarget(31),
      );
    });

    test('reads the product id from the bare path of a warm link', () {
      // Flutter pushes only the path when the app is already running.
      expect(
        DeepLinkParser.parse('/product/42'),
        const ProductDetailsTarget(42),
      );
    });

    test('ignores query parameters and trailing slashes', () {
      expect(
        DeepLinkParser.parse(
          'https://shop.huma-volve.com/product/9/?utm_source=push',
        ),
        const ProductDetailsTarget(9),
      );
    });

    test('returns null for a missing product id', () {
      expect(DeepLinkParser.parse('/product'), isNull);
    });

    test('returns null for a non numeric product id', () {
      expect(DeepLinkParser.parse('/product/abc'), isNull);
    });

    test('returns null for a non positive product id', () {
      expect(DeepLinkParser.parse('/product/0'), isNull);
      expect(DeepLinkParser.parse('/product/-3'), isNull);
    });

    test('returns null for an unrelated path', () {
      expect(DeepLinkParser.parse('/cart'), isNull);
    });

    test('returns null for empty or null locations', () {
      expect(DeepLinkParser.parse(null), isNull);
      expect(DeepLinkParser.parse('   '), isNull);
    });
  });
}
