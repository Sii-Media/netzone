import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class GetDealsItemsByCatUseCase
    extends UseCase<DealsItemsResponse, DealsItemsParams> {
  final DealsRepository dealsRepository;

  GetDealsItemsByCatUseCase({required this.dealsRepository});
  @override
  Future<Either<Failure, DealsItemsResponse>> call(params) {
    return dealsRepository.getDealsByCategory(
      category: params.category,
      country: params.country,
      companyName: params.companyName,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class DealsItemsParams {
  final String category;
  final String country;
  final String? companyName;
  final int? minPrice;
  final int? maxPrice;
  DealsItemsParams({
    required this.category,
    required this.country,
    this.companyName,
    this.minPrice,
    this.maxPrice,
  });
}
