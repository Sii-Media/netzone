import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_response.dart';
import 'package:netzoon/domain/aramex/repositories/aramex_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class CalculateRateUseCase
    extends UseCase<CalculateRateResponse, CalculateRateInputData> {
  final AramexRepository aramexRepository;

  CalculateRateUseCase({required this.aramexRepository});

  @override
  Future<Either<Failure, CalculateRateResponse>> call(
      CalculateRateInputData params) {
    return aramexRepository.calculateRate(calculateRateInputData: params);
  }
}
