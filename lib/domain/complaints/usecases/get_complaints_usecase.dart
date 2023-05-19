import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/complaints/entities/complaints_response.dart';
import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class GetComplaintsUseCase extends UseCase<ComplaintsResponse, NoParams> {
  final ComplaintsRepository complaintsRepository;

  GetComplaintsUseCase({required this.complaintsRepository});
  @override
  Future<Either<Failure, ComplaintsResponse>> call(NoParams params) {
    return complaintsRepository.getComplaints();
  }
}
