import 'package:equatable/equatable.dart';

class Governmental extends Equatable {
  final String name;
  final List<String> images;

  const Governmental({
    required this.name,
    required this.images,
  });
  @override
  List<Object?> get props => [name, images];
}
