import 'package:equatable/equatable.dart';

class DepartmentsCategories extends Equatable {
  final String? id;
  final String name;
  final String? nameAr;
  final String? department;
  final String? imageUrl;
  final List<String>? products;

  const DepartmentsCategories({
    this.id,
    required this.name,
    this.nameAr,
    this.department,
    this.imageUrl,
    this.products,
  });
  @override
  List<Object?> get props => [id, name, nameAr, department, imageUrl, products];
}
