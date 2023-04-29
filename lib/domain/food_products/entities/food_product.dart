import 'package:equatable/equatable.dart';

class FoodProduct extends Equatable {
  final String name;
  final String imgUrl;

  const FoodProduct({required this.name, required this.imgUrl});
  @override
  List<Object?> get props => [name, imgUrl];
}
