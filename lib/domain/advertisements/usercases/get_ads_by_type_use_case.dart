import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAdsByTypeUseCase extends UseCase<Advertising, GetAdsByTypeParams> {
  final AdvertismentRepository advertismentRepository;

  GetAdsByTypeUseCase({required this.advertismentRepository});

  @override
  Future<Either<Failure, Advertising>> call(GetAdsByTypeParams params) {
    return advertismentRepository.getAdvertisementByType(
        userAdvertisingType: params.userAdvertisingType);
  }
}

class GetAdsByTypeParams {
  final String userAdvertisingType;

  GetAdsByTypeParams({required this.userAdvertisingType});
}
