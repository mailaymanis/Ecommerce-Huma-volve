import 'package:ecommerce_app_huma_volve/core/error/failures.dart';
import 'package:ecommerce_app_huma_volve/core/error/result.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;

  @override
  Future<Result<List<CartItem>>> getCartItems() async {
    try {
      return Success(await _localDataSource.fetchCartItems());
    } on Exception catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }
}
