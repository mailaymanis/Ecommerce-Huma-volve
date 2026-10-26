import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class ProductDetailsRemoteDataSource {
  const ProductDetailsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<ProductModel> fetchProduct(int productId) async {
    final response =
        await _apiClient.get(ApiConstants.productUrl(productId)) as Map;
    return ProductModel.fromJson(data: Map<String, dynamic>.from(response));
  }
}
