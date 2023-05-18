part of 'cart_bloc_bloc.dart';

abstract class CartBlocEvent extends Equatable {
  const CartBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartBlocEvent {}

class AddToCart extends CartBlocEvent {
  final CategoryProducts product;

  const AddToCart({required this.product});
  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartBlocEvent {
  final CategoryProducts product;

  const RemoveFromCart({required this.product});

  @override
  List<Object> get props => [product];
}

class ChangeQuantity extends CartBlocEvent {
  final CategoryProducts product;
  final int quantity;

  const ChangeQuantity({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
