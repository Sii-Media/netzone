import 'package:equatable/equatable.dart';

class Perfume extends Equatable {
  final String name;
  final String imgUrl;

  const Perfume({required this.name, required this.imgUrl});
  @override
  List<Object?> get props => [name, imgUrl];
}
