import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/complaints/usecases/add_complaints_usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'add_complaint_event.dart';
part 'add_complaint_state.dart';

class AddComplaintBloc extends Bloc<AddComplaintEvent, AddComplaintState> {
  final AddComplaintsUseCase addComplaintsUseCase;
  AddComplaintBloc({required this.addComplaintsUseCase})
      : super(AddComplaintInitial()) {
    on<PostComplaintEvent>((event, emit) async {
      emit(AddComplaintInProgress());
      final failureOrSuccess = await addComplaintsUseCase(
          AddComplaintsParams(address: event.address, text: event.text));
      emit(
        failureOrSuccess.fold(
          (failure) =>
              AddComplaintFailure(message: mapFailureToString(failure)),
          (complaints) => AddComplaintSuccess(complaints: complaints),
        ),
      );
    });
  }
}
