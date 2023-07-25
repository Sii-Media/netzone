import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class AddCompanyServiceUseCase
    extends UseCase<String, AddCompanyServiceParams> {
  final LocalCompanyRepository localCompanyRepository;

  AddCompanyServiceUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, String>> call(AddCompanyServiceParams params) {
    return localCompanyRepository.addCompanyService(
        title: params.title,
        description: params.description,
        price: params.price,
        owner: params.owner);
  }
}

class AddCompanyServiceParams {
  final String title;
  final String description;
  final int price;
  final String owner;

  AddCompanyServiceParams({
    required this.title,
    required this.description,
    required this.price,
    required this.owner,
  });
}
