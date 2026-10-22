import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_app_huma_volve/core/helper/api_services.dart';
import 'package:ecommerce_app_huma_volve/core/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/core/models/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/logic/home_states.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  void getCategories() async {
    emit(CategoryLoadingState());
    try {
      http.Response response = await http.get(
        Uri.parse(ApiServices.categoriesUrl),
      );
      if (response.statusCode == 200) {
        var jsonDecoded = jsonDecode(response.body) as List;
        categories = [
          CategoryModel(name: 'All'),
          ...jsonDecoded.take(5).map((e) => CategoryModel.fromJson(data: e)),
        ];
        emit(CategorySuccessState());
        log("categories list added successfully");
      } else {
        emit(CategoryErrorState(message: response.body));
        log("categories list failed to load");
      }
    } catch (e) {
      emit(CategoryErrorState(message: e.toString()));
    }
  }

  void getProducts({int? categoryId}) async {
    emit(ProductsLoadingState());
    try {
      final Uri uri = categoryId == null
          ? Uri.parse("${ApiServices.productsUrl}?offset=0&limit=10")
          : Uri.parse(ApiServices.categoryProductsUrl(categoryId));
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        var jsonDecoded = jsonDecode(response.body) as List;
        products = jsonDecoded
            .take(10)
            .map((e) => ProductModel.fromJson(data: e))
            .toList();
        emit(ProductsSuccessState());
        log("products list added successfully (${products.length})");
      } else {
        emit(ProductsErrorState(message: response.body));
        log("products list failed to load");
      }
    } catch (e) {
      emit(ProductsErrorState(message: e.toString()));
    }
  }
}
