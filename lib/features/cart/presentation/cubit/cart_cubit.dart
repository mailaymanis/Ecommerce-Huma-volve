import 'package:ecommerce_app_huma_volve/core/error/result.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/entities/cart_summary.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app_huma_volve/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:ecommerce_app_huma_volve/features/cart/presentation/cubit/cart_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit({CartRepository? repository})
    : this._(repository ?? const CartRepositoryImpl(CartLocalDataSource()));

  CartCubit._(CartRepository repository)
    : _getCartItems = GetCartItemsUseCase(repository),
      super(CartInitialState());

  final GetCartItemsUseCase _getCartItems;

  List<CartItem> items = [];

  CartSummary get summary => CartSummary.fromItems(items);

  Future<void> getCartItems() async {
    emit(CartLoadingState());
    final result = await _getCartItems();
    switch (result) {
      case Success(:final data):
        items = data;
        emit(CartSuccessState());
      case FailureResult(:final failure):
        emit(CartErrorState(message: failure.message));
    }
  }
}
