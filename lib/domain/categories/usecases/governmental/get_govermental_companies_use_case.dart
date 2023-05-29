import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_companies.dart';
import 'package:netzoon/domain/categories/repositories/govermental_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import '../../../core/usecase/usecase.dart';

class GetGovermentalCompaniesUseCase
    extends UseCase<GovermentalCompanies, String> {
  final GovermentalRepository govermentalRepository;

  GetGovermentalCompaniesUseCase({required this.govermentalRepository});
  @override
  Future<Either<Failure, GovermentalCompanies>> call(String params) {
    return govermentalRepository.getGovermentalCompanies(id: params);
  }
}
