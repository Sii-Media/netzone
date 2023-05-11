import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAdvertismentsUseCase extends UseCase<Advertising, NoParams> {
  final AdvertismentRepository advertismentRepository;

  GetAdvertismentsUseCase({required this.advertismentRepository});
  @override
  Future<Either<Failure, Advertising>> call(params) {
    return advertismentRepository.getAllAds();
  }
}
