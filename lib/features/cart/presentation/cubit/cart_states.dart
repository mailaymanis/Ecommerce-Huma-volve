sealed class CartStates {}

//create cart initial state
class CartInitialState extends CartStates {}

//create cart states
class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {}

class CartErrorState extends CartStates {
  final String message;

  CartErrorState({required this.message});
}
