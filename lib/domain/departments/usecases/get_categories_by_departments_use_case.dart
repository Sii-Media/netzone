import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/departments/entities/departments_categories/departments_categories_response.dart';
import 'package:netzoon/domain/departments/repositories/departments_repository.dart';

class GetCategoriesByDepartmentUsecase
    extends UseCase<DepartmentsCategoriesResponse, DepartmentsCatParams> {
  final DepartmentRepository departmentRepository;

  GetCategoriesByDepartmentUsecase({required this.departmentRepository});
  @override
  Future<Either<Failure, DepartmentsCategoriesResponse>> call(
      DepartmentsCatParams params) {
    return departmentRepository.getCategoriesByDepartment(
        department: params.department);
  }
}

class DepartmentsCatParams {
  final String department;

  DepartmentsCatParams({required this.department});
}
