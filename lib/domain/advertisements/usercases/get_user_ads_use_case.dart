import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../core/usecase/usecase.dart';
import '../repositories/advertisment_repository.dart';

class GetUserAdsUseCase extends UseCase<Advertising, String> {
  final AdvertismentRepository advertismentRepository;

  GetUserAdsUseCase({required this.advertismentRepository});

  @override
  Future<Either<Failure, Advertising>> call(String params) {
    return advertismentRepository.getUserAds(userId: params);
  }
}
