import 'package:equatable/equatable.dart';

class DepartmentsCategories extends Equatable {
  final String? id;
  final String name;
  final String? department;
  final String? imageUrl;
  final List<String>? products;

  const DepartmentsCategories({
    this.id,
    required this.name,
    this.department,
    this.imageUrl,
    this.products,
  });
  @override
  List<Object?> get props => [id, name, department, imageUrl, products];
}
