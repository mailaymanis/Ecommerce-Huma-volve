class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/users';
  static const String categoriesUrl = '$baseUrl/categories';
  static const String productsUrl = '$baseUrl/products';

  // Products that belong to a specific category.
  static String categoryProductsUrl(int categoryId) =>
      '$categoriesUrl/$categoryId/products';
}
