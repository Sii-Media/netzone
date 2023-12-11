import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class GetUserDealsUseCase extends UseCase<List<DealsItems>, String> {
  final DealsRepository dealsRepository;

  GetUserDealsUseCase({required this.dealsRepository});
  @override
  Future<Either<Failure, List<DealsItems>>> call(String params) {
    return dealsRepository.getUserDeals(userId: params);
  }
}
