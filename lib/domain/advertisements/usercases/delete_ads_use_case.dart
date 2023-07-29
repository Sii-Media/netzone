import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../repositories/advertisment_repository.dart';

class DeleteAdsUseCase extends UseCase<String, String> {
  final AdvertismentRepository advertismentRepository;

  DeleteAdsUseCase({required this.advertismentRepository});

  @override
  Future<Either<Failure, String>> call(String params) {
    return advertismentRepository.deleteAdvertisement(id: params);
  }
}
