import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories.dart';

class DepartmentsCategoriesResponse extends Equatable {
  final String message;
  final List<DepartmentsCategories> departmentsCat;

  const DepartmentsCategoriesResponse({
    required this.message,
    required this.departmentsCat,
  });
  @override
  List<Object?> get props => [message, departmentsCat];
}
