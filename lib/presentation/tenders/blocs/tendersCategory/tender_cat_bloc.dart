import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tender_result.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_cat_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'tender_cat_event.dart';
part 'tender_cat_state.dart';

class TenderCatBloc extends Bloc<TenderCatEvent, TenderCatState> {
  final GetTendersCategoriesUseCase getTendersCategoriesUseCase;
  TenderCatBloc({required this.getTendersCategoriesUseCase})
      : super(TenderCatInitial()) {
    on<GetAllTendersCatEvent>(
      (event, emit) async {
        emit(TenderCatInProgress());
        final failureOrTenderCat =
            await getTendersCategoriesUseCase(NoParams());
        emit(failureOrTenderCat.fold(
          (failure) => TenderCatFailure(
            message: mapFailureToString(failure),
          ),
          (tenderCat) => TenderCatSuccess(tenderCat: tenderCat.tendersCat),
        ));
      },
    );
  }
}
