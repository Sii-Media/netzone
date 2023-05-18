import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/openions/entities/openion_response.dart';
import 'package:netzoon/domain/openions/repositories/openion_repository.dart';

class AddOpenionUseCase extends UseCase<OpenionResponse, AddOpenionParams> {
  final OpenionsRepository openionsRepository;

  AddOpenionUseCase({required this.openionsRepository});
  @override
  Future<Either<Failure, OpenionResponse>> call(AddOpenionParams params) {
    return openionsRepository.addOpenion(text: params.text);
  }
}

class AddOpenionParams {
  final String text;

  AddOpenionParams({required this.text});
}
