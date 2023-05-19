import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/advertisements/usercases/add_ads_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'add_ads_event.dart';
part 'add_ads_state.dart';

class AddAdsBloc extends Bloc<AddAdsEvent, AddAdsState> {
  final AddAdvertisementUseCase addAdvertisementUseCase;
  AddAdsBloc({required this.addAdvertisementUseCase}) : super(AddAdsInitial()) {
    on<AddAdsRequestedEvent>(
      (event, emit) async {
        emit(AddAdsInProgress());
        final failureOrSuccess =
            await addAdvertisementUseCase(AddAdvertisementParams(
          advertisingTitle: event.advertisingTitle,
          advertisingStartDate: event.advertisingStartDate,
          advertisingEndDate: event.advertisingEndDate,
          advertisingDescription: event.advertisingDescription,
          image: event.image,
          advertisingCountryAlphaCode: event.advertisingCountryAlphaCode,
          advertisingBrand: event.advertisingBrand,
          advertisingYear: event.advertisingYear,
          advertisingLocation: event.advertisingLocation,
          advertisingPrice: event.advertisingPrice,
          advertisingType: event.advertisingType,
        ));

        emit(
          failureOrSuccess.fold(
            (failure) => AddAdsFailure(message: mapFailureToString(failure)),
            (msg) => AddAdsSuccess(msg: msg),
          ),
        );
      },
    );
  }
}
