import 'package:ecommerce_app_huma_volve/core/error/exceptions.dart';
import 'package:ecommerce_app_huma_volve/core/error/failures.dart';
import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

import '../../domain/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  const ProductDetailsRepositoryImpl(this._remoteDataSource);

  final ProductDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Product>> getProduct(int productId) async {
    try {
      final model = await _remoteDataSource.fetchProduct(productId);
      return Success(model);
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }
}
