import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String name;
  final String image;
  final double price;

  const Cart({
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [name, image, price];
}
