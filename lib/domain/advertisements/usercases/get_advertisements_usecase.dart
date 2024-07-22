import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/advertisements/repositories/advertisment_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAdvertismentsUseCase extends UseCase<Advertising, GetAdsParams> {
  final AdvertismentRepository advertismentRepository;

  GetAdvertismentsUseCase({required this.advertismentRepository});
  @override
  Future<Either<Failure, Advertising>> call(params) {
    return advertismentRepository.getAllAds(
      owner: params.owner,
      priceMin: params.priceMin,
      priceMax: params.priceMax,
      purchasable: params.purchasable,
      year: params.year,
      country: params.country,
    );
  }
}

class GetAdsParams {
  final String? owner;
  final int? priceMin;
  final int? priceMax;
  final bool? purchasable;
  final String? year;
  final String? country;

  GetAdsParams(
      {this.owner,
      this.priceMin,
      this.priceMax,
      this.purchasable,
      this.year,
      this.country});
}
