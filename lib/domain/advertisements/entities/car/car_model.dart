import 'package:equatable/equatable.dart';

class CarType extends Equatable {
  final String name;
  final List<String> categories;

  const CarType({required this.name, required this.categories});

  @override
  List<Object?> get props => [name, categories];
}
