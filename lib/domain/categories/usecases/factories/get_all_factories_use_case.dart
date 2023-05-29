import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';
import 'package:netzoon/domain/categories/repositories/factories_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllFactoriesUseCase extends UseCase<List<Factories>, NoParams> {
  final FactoriesRepository factoriesRepository;

  GetAllFactoriesUseCase({required this.factoriesRepository});
  @override
  Future<Either<Failure, List<Factories>>> call(NoParams params) {
    return factoriesRepository.getAllFactories();
  }
}
