import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/complaints/repositories/complaints_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';

class AddComplaintsUseCase extends UseCase<String, AddComplaintsParams> {
  final ComplaintsRepository complaintsRepository;

  AddComplaintsUseCase({required this.complaintsRepository});
  @override
  Future<Either<Failure, String>> call(AddComplaintsParams params) {
    return complaintsRepository.addComplaints(
        address: params.address, text: params.text);
  }
}

class AddComplaintsParams {
  final String address;
  final String text;

  AddComplaintsParams({
    required this.address,
    required this.text,
  });
}
