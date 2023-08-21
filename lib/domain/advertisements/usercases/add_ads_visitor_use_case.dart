import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';

class AddAdsVisitorUseCase extends UseCase<String, AddAdsVisitorParams> {
  final AdvertismentRepository advertismentRepository;

  AddAdsVisitorUseCase({required this.advertismentRepository});
  @override
  Future<Either<Failure, String>> call(AddAdsVisitorParams params) {
    return advertismentRepository.addAdsVisitor(
        adsId: params.adsId, viewerUserId: params.viewerUserId);
  }
}

class AddAdsVisitorParams {
  final String adsId;
  final String viewerUserId;

  AddAdsVisitorParams({required this.adsId, required this.viewerUserId});
}
