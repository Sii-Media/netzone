import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tenders_items_response.dart';
import 'package:netzoon/domain/tenders/repositories/tenders_repository.dart';

class GetTendersItem extends UseCase<TenderItemResponse, NoParams> {
  final TenderRepository tenderRepository;

  GetTendersItem({required this.tenderRepository});
  @override
  Future<Either<Failure, TenderItemResponse>> call(params) {
    return tenderRepository.getTendersItems();
  }
}
