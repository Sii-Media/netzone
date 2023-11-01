import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_input_data.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_response.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_response.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_input_data.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AramexRepository {
  Future<Either<Failure, CreateShipmentResponse>> createShipment({
    required CreateShipmentInputData createShipmentInputData,
  });

  Future<Either<Failure, CreatePickUpResponse>> createPickUp({
    required CreatePickUpInputData createPickUpInputData,
  });

  Future<Either<Failure, CalculateRateResponse>> calculateRate({
    required CalculateRateInputData calculateRateInputData,
  });
}
