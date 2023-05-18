import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/openions/entities/openion.dart';
import 'package:netzoon/domain/openions/usecases/add_openion_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'add_openion_event.dart';
part 'add_openion_state.dart';

class AddOpenionBloc extends Bloc<AddOpenionEvent, AddOpenionState> {
  final AddOpenionUseCase addOpenionUseCase;
  AddOpenionBloc({required this.addOpenionUseCase})
      : super(AddOpenionInitial()) {
    on<PostOpenionEvent>((event, emit) async {
      emit(AddOpenionInProgress());
      final failureOrOpenion =
          await addOpenionUseCase(AddOpenionParams(text: event.text));
      emit(
        failureOrOpenion.fold(
          (failure) => AddOpenionFailure(message: mapFailureToString(failure)),
          (openion) => AddOpenionSuccess(openion: openion.openions),
        ),
      );
    });
  }
}
