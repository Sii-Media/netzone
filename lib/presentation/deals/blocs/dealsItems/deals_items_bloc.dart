import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';
import 'package:netzoon/domain/deals/usecases/add_deal_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_all_deals_items_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deal_by_id_use_case.dart';
import 'package:netzoon/domain/deals/usecases/get_deals_items_by_cat_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'deals_items_event.dart';
part 'deals_items_state.dart';

class DealsItemsBloc extends Bloc<DealsItemsEvent, DealsItemsState> {
  final GetDealsItemsByCatUseCase getDealsItemsByCat;
  final GetDealsItemUsecase getDealsItemUsecase;
  final AddDealUseCase addDealUseCase;
  final GetDealByIdUseCase getDealByIdUseCase;
  final GetCountryUseCase getCountryUseCase;
  DealsItemsBloc({
    required this.addDealUseCase,
    required this.getDealsItemsByCat,
    required this.getDealsItemUsecase,
    required this.getDealByIdUseCase,
    required this.getCountryUseCase,
  }) : super(DealsItemsInitial()) {
    on<DealsItemsByCatEvent>((event, emit) async {
      emit(DealsItemsInProgress());

      late String country;
      final result = await getCountryUseCase(NoParams());
      result.fold((l) => null, (r) => country = r ?? 'AE');

      final failureOrDealsItems = await getDealsItemsByCat(
          DealsItemsParams(category: event.category, country: country));
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
        late String country;
        final result = await getCountryUseCase(NoParams());
        result.fold((l) => null, (r) => country = r ?? 'AE');
        final failureOrDealsItems = await getDealsItemUsecase(country);
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
      late String country;
      final result = await getCountryUseCase(NoParams());
      result.fold((l) => null, (r) => country = r ?? 'AE');
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
        country: country,
      ));

      emit(
        failureOrDealsItems.fold(
          (failure) => DealsItemsFailure(message: mapFailureToString(failure)),
          (message) => AddDealSuccess(message: message),
        ),
      );
    });
    on<GetDealByIdEvent>((event, emit) async {
      emit(DealsItemsInProgress());

      final deal = await getDealByIdUseCase(event.id);

      emit(
        deal.fold(
          (failure) => DealsItemsFailure(message: mapFailureToString(failure)),
          (deal) => GetDealByIdSuccess(deal: deal),
        ),
      );
    });
  }
}
