part of 'cart_bloc_bloc.dart';

abstract class CartBlocState extends Equatable {
  const CartBlocState();

  @override
  List<CategoryProducts> get props => [];
}

class CartBlocInitial extends CartBlocState {}

class CartLoading extends CartBlocState {}

class CartLoaded extends CartBlocState {
  final List<CategoryProducts> items;

  final double totalPrice;
  final num totalQuantity;
  final bool? outStock;
  const CartLoaded({
    required this.totalQuantity,
    required this.items,
    required this.totalPrice,
    this.outStock = false,
  });

  @override
  List<CategoryProducts> get props => items;
}
