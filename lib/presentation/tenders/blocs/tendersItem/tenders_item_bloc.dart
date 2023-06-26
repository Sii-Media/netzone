import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tender_item.dart';
import 'package:netzoon/domain/tenders/usecases/add_tender_use_case.dart';
import 'package:netzoon/domain/tenders/usecases/get_all_tenders_items.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_min.dart';
import 'package:netzoon/domain/tenders/usecases/get_tenders_items_by_max.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'tenders_item_event.dart';
part 'tenders_item_state.dart';

class TendersItemBloc extends Bloc<TendersItemEvent, TendersItemState> {
  final GetTendersItemByMin getTendersItemByMin;
  final GetTendersItemByMax getTendersItemByMax;
  final GetTendersItem getTendersItem;
  final AddTenderUseCase addTenderUseCase;
  TendersItemBloc({
    required this.getTendersItemByMin,
    required this.getTendersItemByMax,
    required this.getTendersItem,
    required this.addTenderUseCase,
  }) : super(TendersItemInitial()) {
    on<GetTendersItemByMinEvent>(
      (event, emit) async {
        emit(TendersItemInProgress());
        final failureOrTenderItem = await getTendersItemByMin(
          TendersItemByMinParams(category: event.category),
        );
        emit(
          failureOrTenderItem.fold(
              (failure) =>
                  TendersItemFailure(message: mapFailureToString(failure)),
              (tenderItem) {
            return TendersItemSuccess(tenderItems: tenderItem.tenderItems);
          }),
        );
      },
    );
    on<GetTendersItemByMaxEvent>((event, emit) async {
      emit(TendersItemInProgress());
      final failureOrTenderItem = await getTendersItemByMax(
        TendersItemParams(category: event.category),
      );
      emit(
        failureOrTenderItem.fold(
            (failure) =>
                TendersItemFailure(message: mapFailureToString(failure)),
            (tenderItem) {
          return TendersItemSuccess(tenderItems: tenderItem.tenderItems);
        }),
      );
    });

    on<GetTendersItemEvent>((event, emit) async {
      emit(TendersItemInProgress());
      final failureOrTenderItem = await getTendersItem(NoParams());
      emit(
        failureOrTenderItem.fold(
            (failure) =>
                TendersItemFailure(message: mapFailureToString(failure)),
            (tenderItem) {
          return TendersItemSuccess(tenderItems: tenderItem.tenderItems);
        }),
      );
    });
    on<AddTenderEvent>((event, emit) async {
      emit(TendersItemInProgress());
      final failureOrSuccess = await addTenderUseCase(AddTenderParams(
        nameAr: event.nameAr,
        nameEn: event.nameEn,
        companyName: event.companyName,
        startDate: event.startDate,
        endDate: event.endDate,
        price: event.price,
        tenderImage: event.tenderImage,
        category: event.category,
      ));

      emit(
        failureOrSuccess.fold(
          (failure) => TendersItemFailure(message: mapFailureToString(failure)),
          (message) => AddTenderSuccess(message: message),
        ),
      );
    });
  }
}
