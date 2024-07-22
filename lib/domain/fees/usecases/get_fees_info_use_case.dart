import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/fees/entities/fees_resposne.dart';
import 'package:netzoon/domain/fees/repositories/fees_repository.dart';

class GetFeesInfoUseCase extends UseCase<FeesResponse, NoParams> {
  final FeesRepository feesRepository;

  GetFeesInfoUseCase({required this.feesRepository});
  @override
  Future<Either<Failure, FeesResponse>> call(NoParams params) {
    return feesRepository.getFeesInfo();
  }
}
