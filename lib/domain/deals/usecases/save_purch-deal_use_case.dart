import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/repositories/deals_repository.dart';

class SavePurchDealUseCase extends UseCase<String, SavePurchDealParams> {
  final DealsRepository dealsRepository;

  SavePurchDealUseCase({required this.dealsRepository});

  @override
  Future<Either<Failure, String>> call(SavePurchDealParams params) {
    return dealsRepository.savePurchDeal(
        userId: params.userId,
        buyerId: params.buyerId,
        deal: params.deal,
        grandTotal: params.grandTotal);
  }
}

class SavePurchDealParams {
  final String userId;
  final String buyerId;
  final String deal;
  final double grandTotal;

  SavePurchDealParams(
      {required this.userId,
      required this.buyerId,
      required this.deal,
      required this.grandTotal});
}
