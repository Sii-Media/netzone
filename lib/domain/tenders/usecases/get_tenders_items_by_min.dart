import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class GetTendersItemByMin
    extends UseCase<TenderItemResponse, TendersItemByMinParams> {
  final TenderRepository tenderRepository;

  GetTendersItemByMin({required this.tenderRepository});
  @override
  Future<Either<Failure, TenderItemResponse>> call(
      TendersItemByMinParams params) {
    return tenderRepository.getTendersItemsByMin(category: params.category);
  }
}

class TendersItemByMinParams {
  final String category;

  TendersItemByMinParams({required this.category});
}
