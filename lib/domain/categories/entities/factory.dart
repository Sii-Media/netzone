import 'package:equatable/equatable.dart';

class Factory extends Equatable {
  final String name;
  final String imgurl;

  const Factory({required this.name, required this.imgurl});
  @override
  List<Object?> get props => [name, imgurl];
}
