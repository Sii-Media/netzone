import 'package:equatable/equatable.dart';

class WomanFashion extends Equatable {
  final String name;
  final String imgUrl;

  const WomanFashion({required this.name, required this.imgUrl});

  @override
  List<Object?> get props => [name, imgUrl];
}
