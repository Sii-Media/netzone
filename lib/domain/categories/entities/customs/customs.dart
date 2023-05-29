import 'package:equatable/equatable.dart';

class Customs extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Customs({required this.id, required this.name, required this.imageUrl});
  @override
  List<Object?> get props => [id, name, imageUrl];
}
