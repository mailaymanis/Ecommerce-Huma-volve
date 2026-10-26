sealed class ProductDetailsStates {}

//create product details loading state
class ProductDetailsLoadingState extends ProductDetailsStates {}

class ProductDetailsSuccessState extends ProductDetailsStates {}

class ProductDetailsErrorState extends ProductDetailsStates {
  final String message;

  ProductDetailsErrorState({required this.message});
}
