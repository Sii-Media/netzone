import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company_response.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_response.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class FreeZoneRepository {
  Future<Either<Failure, FreeZoneResponse>> getFreeZonePlaces();
  Future<Either<Failure, FreeZoneCompanyResponse>> getFreeZonePlacesById(
      {required String id});
}
