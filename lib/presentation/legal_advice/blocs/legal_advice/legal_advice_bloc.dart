import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice.dart';
import 'package:netzoon/domain/legal_advice/usecases/get_legal_advices_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'legal_advice_event.dart';
part 'legal_advice_state.dart';

class LegalAdviceBloc extends Bloc<LegalAdviceEvent, LegalAdviceState> {
  final GetLegalAdvicesUseCase getLegalAdvicesUseCase;
  LegalAdviceBloc({required this.getLegalAdvicesUseCase})
      : super(LegalAdviceInitial()) {
    on<GetLegalAdviceEvent>(
      (event, emit) async {
        emit(LegalAdviceProgress());
        final failureOrAdvices = await getLegalAdvicesUseCase(NoParams());

        emit(
          failureOrAdvices.fold(
            (failure) =>
                LegalAdviceFailure(message: mapFailureToString(failure)),
            (legalAdvices) =>
                LegalAdviceSuccess(legalAdvices: legalAdvices.legalAdvices),
          ),
        );
      },
    );
  }
}
