import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_response.dart';
import 'package:netzoon/domain/aramex/repositories/aramex_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class CreateShipmentUseCase
    extends UseCase<CreateShipmentResponse, CreateShipmentInputData> {
  final AramexRepository aramexRepository;

  CreateShipmentUseCase({required this.aramexRepository});
  @override
  Future<Either<Failure, CreateShipmentResponse>> call(
      CreateShipmentInputData params) {
    return aramexRepository.createShipment(createShipmentInputData: params);
  }
}
