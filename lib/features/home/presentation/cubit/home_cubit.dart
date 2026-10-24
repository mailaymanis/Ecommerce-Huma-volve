import 'dart:developer';

import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';
import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/datasources/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/repositories/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit({HomeRepository? repository})
    : this._(
        repository ?? HomeRepositoryImpl(HomeRemoteDataSource(ApiClient())),
      );

  HomeCubit._(HomeRepository repository)
    : _getCategories = GetCategoriesUseCase(repository),
      _getProducts = GetProductsUseCase(repository),
      super(HomeInitialState());

  final GetCategoriesUseCase _getCategories;
  final GetProductsUseCase _getProducts;

  List<Category> categories = [];
  List<Product> products = [];

  // Pagination bookkeeping for the products grid.
  int? _activeCategoryId;
  int _offset = 0;
  int _requestId = 0;
  bool _isLoadingMore = false;
  bool _hasReachedEnd = false;
  String? _loadMoreError;

  bool get isLoadingMore => _isLoadingMore;
  bool get hasReachedEnd => _hasReachedEnd;
  String? get loadMoreError => _loadMoreError;

  Future<void> getCategories() async {
    emit(CategoryLoadingState());
    final result = await _getCategories();
    switch (result) {
      case Success(:final data):
        categories = data;
        emit(CategorySuccessState());
        log("categories list added successfully");
      case FailureResult(:final failure):
        emit(CategoryErrorState(message: failure.message));
        log("categories list failed to load");
    }
  }

  /// Loads the first page of products, replacing the grid.
  Future<void> getProducts({int? categoryId}) async {
    _activeCategoryId = categoryId;
    _offset = 0;
    _isLoadingMore = false;
    _hasReachedEnd = false;
    _loadMoreError = null;
    final requestId = ++_requestId;

    emit(ProductsLoadingState());
    final result = await _getProducts(
      categoryId: categoryId,
      offset: 0,
      limit: AppConstants.productPageSize,
    );
    if (requestId != _requestId) return;

    switch (result) {
      case Success(:final data):
        products = data;
        _offset = data.length;
        _hasReachedEnd = data.length < AppConstants.productPageSize;
        emit(ProductsSuccessState());
        log("products list added successfully (${products.length})");
      case FailureResult(:final failure):
        products = [];
        emit(ProductsErrorState(message: failure.message));
        log("products list failed to load");
    }
  }

  /// Appends the next page of products while keeping the grid in place.
  Future<void> loadMoreProducts({bool retry = false}) async {
    if (_isLoadingMore || _hasReachedEnd || products.isEmpty) return;
    if (state is ProductsLoadingState) return;
    if (_loadMoreError != null && !retry) return;

    _isLoadingMore = true;
    _loadMoreError = null;
    final requestId = ++_requestId;
    emit(ProductsLoadingMoreState());

    final result = await _getProducts(
      categoryId: _activeCategoryId,
      offset: _offset,
      limit: AppConstants.productPageSize,
    );
    if (requestId != _requestId) return;

    _isLoadingMore = false;
    switch (result) {
      case Success(:final data):
        products = [...products, ...data];
        _offset += data.length;
        _hasReachedEnd = data.length < AppConstants.productPageSize;
        emit(ProductsSuccessState());
        log("products page appended successfully (${products.length})");
      case FailureResult(:final failure):
        _loadMoreError = failure.message;
        emit(ProductsLoadMoreErrorState(message: failure.message));
        log("products page failed to load");
    }
  }
}
