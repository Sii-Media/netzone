import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/company_category.dart';

class FreeZoon extends Equatable {
  final String name;
  final String img;
  final List<CompanyCategory> freezoonplaces;

  const FreeZoon({
    required this.name,
    required this.img,
    required this.freezoonplaces,
  });
  @override
  List<Object?> get props => [name, img, freezoonplaces];
}
