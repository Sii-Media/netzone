import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/usecases/add_deal_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'deals_items_event.dart';
part 'deals_items_state.dart';

class DealsItemsBloc extends Bloc<DealsItemsEvent, DealsItemsState> {
  final GetDealsItemsByCatUseCase getDealsItemsByCat;
  final GetDealsItemUsecase getDealsItemUsecase;
  final AddDealUseCase addDealUseCase;
  DealsItemsBloc({
    required this.addDealUseCase,
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
    on<AddDealEvent>((event, emit) async {
      emit(DealsItemsInProgress());
      final failureOrDealsItems = await addDealUseCase(AddDealParams(
        name: event.name,
        companyName: event.companyName,
        dealImage: event.dealImage,
        prevPrice: event.prevPrice,
        currentPrice: event.currentPrice,
        startDate: event.startDate,
        endDate: event.endDate,
        location: event.location,
        category: event.category,
      ));

      emit(
        failureOrDealsItems.fold(
          (failure) => DealsItemsFailure(message: mapFailureToString(failure)),
          (message) => AddDealSuccess(message: message),
        ),
      );
    });
  }
}
