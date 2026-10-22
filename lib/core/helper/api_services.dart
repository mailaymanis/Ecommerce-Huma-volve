class ApiServices {
  static const String loginUrl = "https://api.escuelajs.co/api/v1/auth/login";
  static const String registerUrl = "https://api.escuelajs.co/api/v1/users";
  static const String categoriesUrl =
      "https://api.escuelajs.co/api/v1/categories";
  static const String productsUrl = "https://api.escuelajs.co/api/v1/products";

  //products that belong to a specific category
  static String categoryProductsUrl(int categoryId) =>
      "$categoriesUrl/$categoryId/products";
}
