import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class GetTendersItemByMax
    extends UseCase<TenderItemResponse, TendersItemParams> {
  final TenderRepository tenderRepository;

  GetTendersItemByMax({required this.tenderRepository});
  @override
  Future<Either<Failure, TenderItemResponse>> call(TendersItemParams params) {
    return tenderRepository.getTendersItemsByMax(category: params.category);
  }
}

class TendersItemParams {
  final String category;

  TendersItemParams({required this.category});
}
