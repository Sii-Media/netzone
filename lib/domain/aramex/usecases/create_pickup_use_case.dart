import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_response.dart';
import 'package:netzoon/domain/aramex/repositories/aramex_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class CreatePickUpUseCase
    extends UseCase<CreatePickUpResponse, CreatePickUpInputData> {
  final AramexRepository aramexRepository;

  CreatePickUpUseCase({required this.aramexRepository});

  @override
  Future<Either<Failure, CreatePickUpResponse>> call(
      CreatePickUpInputData params) {
    return aramexRepository.createPickUp(createPickUpInputData: params);
  }
}
