import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/advertisement.dart';
import '../repositories/advertisment_repository.dart';

class GetAdsByIdUseCase extends UseCase<Advertisement, String> {
  final AdvertismentRepository advertismentRepository;

  GetAdsByIdUseCase({required this.advertismentRepository});

  @override
  Future<Either<Failure, Advertisement>> call(String params) {
    return advertismentRepository.getAdsById(id: params);
  }
}
