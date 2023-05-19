import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/complaints/entities/complaints.dart';
import 'package:netzoon/domain/complaints/usecases/get_complaints_usecase.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'get_complaint_event.dart';
part 'get_complaint_state.dart';

class GetComplaintBloc extends Bloc<GetComplaintEvent, GetComplaintState> {
  final GetComplaintsUseCase getComplaintsUseCase;
  GetComplaintBloc({required this.getComplaintsUseCase})
      : super(GetComplaintInitial()) {
    on<GetComplaintsRequested>((event, emit) async {
      emit(GetComplaintInProgress());
      final failureOrComplaints = await getComplaintsUseCase(NoParams());

      emit(
        failureOrComplaints.fold(
          (failure) =>
              GetComplaintFailure(message: mapFailureToString(failure)),
          (complaints) =>
              GetComplaintSuccess(complaints: complaints.complaints),
        ),
      );
    });
  }
}
