import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental.dart';
import 'package:netzoon/domain/categories/repositories/govermental_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetAllGovermentalUseCase extends UseCase<List<Govermental>, NoParams> {
  final GovermentalRepository govermentalRepository;

  GetAllGovermentalUseCase({required this.govermentalRepository});
  @override
  Future<Either<Failure, List<Govermental>>> call(NoParams params) {
    return govermentalRepository.getAllGovermental();
  }
}
