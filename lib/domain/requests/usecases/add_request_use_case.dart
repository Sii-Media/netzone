import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/requests/entities/request_response.dart';
import 'package:netzoon/domain/requests/repositories/requests_repository.dart';

class AddRequestUseCase extends UseCase<RequestResponse, AddRequestParams> {
  final RequestsRepository requestsRepository;

  AddRequestUseCase({required this.requestsRepository});
  @override
  Future<Either<Failure, RequestResponse>> call(AddRequestParams params) {
    return requestsRepository.addRequest(
      address: params.address,
      text: params.text,
    );
  }
}

class AddRequestParams {
  final String address;
  final String text;

  AddRequestParams({required this.address, required this.text});
}
