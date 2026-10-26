/// Where an incoming link should take the user.
sealed class DeepLinkTarget {
  const DeepLinkTarget();
}

/// Opens the product details screen for [productId].
final class ProductDetailsTarget extends DeepLinkTarget {
  const ProductDetailsTarget(this.productId);

  final int productId;

  @override
  bool operator ==(Object other) =>
      other is ProductDetailsTarget && other.productId == productId;

  @override
  int get hashCode => productId.hashCode;

  @override
  String toString() => 'ProductDetailsTarget($productId)';
}

/// Parses the location handed to the app by the platform into a target.
///
/// The shapes below are all accepted (they are declared in
/// `android/app/src/main/AndroidManifest.xml`):
///
/// * `ecommerce://shop.huma-volve.com/product/12` — custom scheme link.
/// * `https://shop.huma-volve.com/product/12` — verified web link.
/// * `/product/12` — a warm link, because Flutter keeps only the path when it
///   pushes the incoming URI as a named route.
class DeepLinkParser {
  const DeepLinkParser._();

  /// Path segment that identifies the product details destination.
  static const String productSegment = 'product';

  static DeepLinkTarget? parse(String? location) {
    if (location == null || location.trim().isEmpty) return null;

    final uri = Uri.tryParse(location.trim());
    if (uri == null) return null;

    final segments = <String>[
      // `ecommerce://product/12` is parsed with `product` as the host and `12`
      // as the path, so a custom scheme keeps its host in the segment list.
      if (!_isWebScheme(uri.scheme) && uri.host.isNotEmpty) uri.host,
      ...uri.pathSegments.where((segment) => segment.isNotEmpty),
    ];

    final productIndex = segments.indexOf(productSegment);
    if (productIndex == -1 || productIndex + 1 >= segments.length) return null;

    final productId = int.tryParse(segments[productIndex + 1]);
    if (productId == null || productId <= 0) return null;

    return ProductDetailsTarget(productId);
  }

  static bool _isWebScheme(String scheme) =>
      scheme == 'http' || scheme == 'https';
}
