import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class GetDealsItemUsecase extends UseCase<DealsItemsResponse, NoParams> {
  final DealsRepository dealsRepository;

  GetDealsItemUsecase({required this.dealsRepository});
  @override
  Future<Either<Failure, DealsItemsResponse>> call(NoParams params) {
    return dealsRepository.getDealsItems();
  }
}
