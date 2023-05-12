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
    return dealsRepository.getDealsByCategory(category: params.category);
  }
}

class DealsItemsParams {
  final String category;

  DealsItemsParams({required this.category});
}
