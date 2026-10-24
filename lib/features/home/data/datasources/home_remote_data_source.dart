import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _apiClient.get(ApiConstants.categoriesUrl) as List;
    return response
        .map(
          (item) => CategoryModel.fromJson(
            data: Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<List<ProductModel>> fetchProducts({
    int? categoryId,
    int offset = 0,
    int limit = AppConstants.productPageSize,
  }) async {
    final url = categoryId == null
        ? ApiConstants.productsPageUrl(offset: offset, limit: limit)
        : ApiConstants.categoryProductsUrl(
            categoryId,
            offset: offset,
            limit: limit,
          );

    final response = await _apiClient.get(url) as List;
    return response
        .map(
          (item) => ProductModel.fromJson(
            data: Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
