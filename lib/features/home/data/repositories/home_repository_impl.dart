import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';
import 'package:ecommerce_app_huma_volve/core/error/exceptions.dart';
import 'package:ecommerce_app_huma_volve/core/error/failures.dart';
import 'package:ecommerce_app_huma_volve/core/error/result.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final models = await _remoteDataSource.fetchCategories();
      final categories = <Category>[
        const Category(name: AppConstants.allCategoryName),
        ...models.take(AppConstants.categoryLimit),
      ];
      return Success(categories);
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Product>>> getProducts({
    int? categoryId,
    int offset = 0,
    int limit = AppConstants.productPageSize,
  }) async {
    try {
      final models = await _remoteDataSource.fetchProducts(
        categoryId: categoryId,
        offset: offset,
        limit: limit,
      );
      return Success(models.take(limit).toList());
    } on ServerException catch (e) {
      return FailureResult(ServerFailure(e.message));
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }
}
