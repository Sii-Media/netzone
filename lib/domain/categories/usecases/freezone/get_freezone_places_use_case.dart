import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_response.dart';
import 'package:netzoon/domain/categories/repositories/freezone_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetFreeZonePlacesUseCase extends UseCase<FreeZoneResponse, NoParams> {
  final FreeZoneRepository freeZoneRepository;

  GetFreeZonePlacesUseCase({required this.freeZoneRepository});
  @override
  Future<Either<Failure, FreeZoneResponse>> call(NoParams params) {
    return freeZoneRepository.getFreeZonePlaces();
  }
}
