part of 'add_product_bloc.dart';

abstract class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductState {}

class AddProductInProgress extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final String product;

  const AddProductSuccess({required this.product});
}

class AddProductFailure extends AddProductState {
  final String message;

  const AddProductFailure({required this.message});
}
