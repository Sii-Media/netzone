import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_response.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class GetDealsCategoriesUseCase extends UseCase<DealsResponse, NoParams> {
  final DealsRepository dealsRepository;

  GetDealsCategoriesUseCase({required this.dealsRepository});
  @override
  Future<Either<Failure, DealsResponse>> call(NoParams params) {
    return dealsRepository.getDealsCategories();
  }
}
