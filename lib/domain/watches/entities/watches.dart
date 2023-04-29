import 'package:equatable/equatable.dart';

class Watches extends Equatable {
  final String name;
  final String imgUrl;

  const Watches({required this.name, required this.imgUrl});

  @override
  List<Object?> get props => [name, imgUrl];
}
