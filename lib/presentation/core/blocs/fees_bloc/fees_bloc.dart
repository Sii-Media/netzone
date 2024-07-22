import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/fees/entities/fees_resposne.dart';
import 'package:netzoon/domain/fees/usecases/get_fees_info_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'fees_event.dart';
part 'fees_state.dart';

class FeesBloc extends Bloc<FeesEvent, FeesState> {
  final GetFeesInfoUseCase getFeesInfoUseCase;
  FeesBloc({required this.getFeesInfoUseCase}) : super(FeesInitial()) {
    on<GetFeesInfoEvent>((event, emit) async {
      emit(GetFeesInProgress());
      final fees = await getFeesInfoUseCase(NoParams());
      emit(fees.fold((l) => GetFeesFailure(message: mapFailureToString(l)),
          (r) => GetFeesSuccess(fees: r)));
    });
  }
}
