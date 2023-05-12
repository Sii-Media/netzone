import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_result.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_cat_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'deals_categoty_event.dart';
part 'deals_categoty_state.dart';

class DealsCategotyBloc extends Bloc<DealsCategotyEvent, DealsCategotyState> {
  final GetDealsCategoriesUseCase getDealsCategoriesUseCase;
  DealsCategotyBloc({required this.getDealsCategoriesUseCase})
      : super(DealsCategotyInitial()) {
    on<GetDealsCategoryEvent>(
      (event, emit) async {
        emit(DealsCategotyInProgress());
        final failureOrDealsCat = await getDealsCategoriesUseCase(NoParams());
        emit(
          failureOrDealsCat.fold(
            (failure) => DealsCategotyFailure(
              message: mapFailureToString(failure),
            ),
            (dealsCat) {
              return DealsCategotySuccess(dealsCat: dealsCat.dealsCat);
            },
          ),
        );
      },
    );
  }
}
