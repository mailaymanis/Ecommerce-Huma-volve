sealed class HomeStates {}

//create home initial state
class HomeInitialState extends HomeStates {}

//create category states
class CategoryLoadingState extends HomeStates {}

class CategorySuccessState extends HomeStates {}

class CategoryErrorState extends HomeStates {
  final String message;

  CategoryErrorState({required this.message});
}

//create product states
class ProductsLoadingState extends HomeStates {}

class ProductsSuccessState extends HomeStates {}

//create product pagination states
class ProductsLoadingMoreState extends HomeStates {}

class ProductsLoadMoreErrorState extends HomeStates {
  final String message;

  ProductsLoadMoreErrorState({required this.message});
}

class ProductsErrorState extends HomeStates {
  final String message;

  ProductsErrorState({required this.message});
}
