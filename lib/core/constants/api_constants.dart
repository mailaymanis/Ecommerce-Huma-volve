class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/users';
  static const String categoriesUrl = '$baseUrl/categories';
  static const String productsUrl = '$baseUrl/products';

  // A single product, used when a deep link only carries the product id.
  static String productUrl(int productId) => '$productsUrl/$productId';

  // A single products page, used by the paginated home grid.
  static String productsPageUrl({required int offset, required int limit}) =>
      '$productsUrl?offset=$offset&limit=$limit';

  // Products that belong to a specific category.
  static String categoryProductsUrl(
    int categoryId, {
    required int offset,
    required int limit,
  }) => '$categoriesUrl/$categoryId/products?offset=$offset&limit=$limit';
}
