import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/requests/entities/request.dart';
import 'package:netzoon/domain/requests/usecases/add_request_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'add_request_event.dart';
part 'add_request_state.dart';

class AddRequestBloc extends Bloc<AddRequestEvent, AddRequestState> {
  final AddRequestUseCase addRequestUseCase;
  AddRequestBloc({required this.addRequestUseCase})
      : super(AddRequestInitial()) {
    on<PostRequestEvent>(
      (event, emit) async {
        emit(AddRequestInProgress());
        final failureOrRequest = await addRequestUseCase(
            AddRequestParams(address: event.address, text: event.text));
        emit(
          failureOrRequest.fold(
            (failure) => AddRequestFailure(
                message: mapFailureToString(failure), failure: failure),
            (requests) => AddRequestSuccess(requests: requests.requests),
          ),
        );
      },
    );
  }
}
