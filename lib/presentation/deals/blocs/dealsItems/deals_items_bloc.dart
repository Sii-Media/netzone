import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'deals_items_event.dart';
part 'deals_items_state.dart';

class DealsItemsBloc extends Bloc<DealsItemsEvent, DealsItemsState> {
  final GetDealsItemsByCatUseCase getDealsItemsByCat;
  final GetDealsItemUsecase getDealsItemUsecase;
  DealsItemsBloc({
    required this.getDealsItemsByCat,
    required this.getDealsItemUsecase,
  }) : super(DealsItemsInitial()) {
    on<DealsItemsByCatEvent>((event, emit) async {
      emit(DealsItemsInProgress());
      final failureOrDealsItems =
          await getDealsItemsByCat(DealsItemsParams(category: event.category));
      emit(
        failureOrDealsItems.fold(
          (failure) => DealsItemsFailure(message: mapFailureToString(failure)),
          (dealsItems) {
            return DealsItemsSuccess(dealsItems: dealsItems.dealsItems);
          },
        ),
      );
    });
    on<GetDealsItemEvent>(
      (event, emit) async {
        emit(DealsItemsInProgress());
        final failureOrDealsItems = await getDealsItemUsecase(NoParams());
        emit(
          failureOrDealsItems.fold(
              (failure) =>
                  DealsItemsFailure(message: mapFailureToString(failure)),
              (dealsItems) {
            return DealsItemsSuccess(dealsItems: dealsItems.dealsItems);
          }),
        );
      },
    );
  }
}
