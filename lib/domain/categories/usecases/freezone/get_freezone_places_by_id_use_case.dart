import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company_response.dart';
import 'package:netzoon/domain/categories/repositories/freezone_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetFreeZonePlacesByIdUseCase
    extends UseCase<FreeZoneCompanyResponse, GetFreeZonePlacesByIdParams> {
  final FreeZoneRepository freeZoneRepository;

  GetFreeZonePlacesByIdUseCase({required this.freeZoneRepository});

  @override
  Future<Either<Failure, FreeZoneCompanyResponse>> call(
      GetFreeZonePlacesByIdParams params) {
    return freeZoneRepository.getFreeZonePlacesById(id: params.id);
  }
}

class GetFreeZonePlacesByIdParams {
  final String id;

  GetFreeZonePlacesByIdParams({required this.id});
}
