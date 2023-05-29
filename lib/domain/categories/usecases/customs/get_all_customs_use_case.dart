import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/customs/customs.dart';
import 'package:netzoon/domain/categories/repositories/customs_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllCustomsUseCase extends UseCase<List<Customs>, NoParams> {
  final CustomsRepository customsRepository;

  GetAllCustomsUseCase({required this.customsRepository});
  @override
  Future<Either<Failure, List<Customs>>> call(NoParams params) {
    return customsRepository.getAllCustoms();
  }
}
