import 'dart:developer';

import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/product_details_remote_data_source.dart';
import '../../data/repositories/product_details_repository_impl.dart';
import '../../domain/repositories/product_details_repository.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_states.dart';

/// Loads a single product, used when the screen is opened from a link that
/// only carries a product id.
class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit({ProductDetailsRepository? repository})
    : this._(
        repository ??
            ProductDetailsRepositoryImpl(
              ProductDetailsRemoteDataSource(ApiClient()),
            ),
      );

  ProductDetailsCubit._(ProductDetailsRepository repository)
    : _getProduct = GetProductDetailsUseCase(repository),
      super(ProductDetailsLoadingState());

  final GetProductDetailsUseCase _getProduct;

  Product? product;

  Future<void> getProduct(int productId) async {
    emit(ProductDetailsLoadingState());
    final result = await _getProduct(productId);
    switch (result) {
      case Success(:final data):
        product = data;
        emit(ProductDetailsSuccessState());
        log("product details loaded successfully (${data.id})");
      case FailureResult(:final failure):
        product = null;
        emit(ProductDetailsErrorState(message: failure.message));
        log("product details failed to load ($productId)");
    }
  }
}
