import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

class Cart extends Equatable {
  final CategoryProducts products;
  final int quantity;

  const Cart({
    required this.products,
    required this.quantity,
  });

  @override
  List<Object?> get props => [products, quantity];
}
