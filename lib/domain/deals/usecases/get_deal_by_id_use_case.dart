import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

import '../entities/dealsItems/deals_items.dart';
import '../repositories/deals_repository.dart';

class GetDealByIdUseCase extends UseCase<DealsItems, String> {
  final DealsRepository dealsRepository;

  GetDealByIdUseCase({required this.dealsRepository});

  @override
  Future<Either<Failure, DealsItems>> call(String params) {
    return dealsRepository.getDealById(id: params);
  }
}
