import 'dart:developer';

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

  Future<void> getProducts({int? categoryId}) async {
    emit(ProductsLoadingState());
    final result = await _getProducts(categoryId: categoryId);
    switch (result) {
      case Success(:final data):
        products = data;
        emit(ProductsSuccessState());
        log("products list added successfully (${products.length})");
      case FailureResult(:final failure):
        emit(ProductsErrorState(message: failure.message));
        log("products list failed to load");
    }
  }
}
