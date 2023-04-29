import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/customs_category.dart';

class Customs extends Equatable {
  final String name;
  final String img;
  final List<CustomsCategory> freezoonplaces;

  const Customs({
    required this.name,
    required this.img,
    required this.freezoonplaces,
  });
  @override
  List<Object?> get props => [name, img, freezoonplaces];
}
