import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/advertisements/usercases/add_ads_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'add_ads_event.dart';
part 'add_ads_state.dart';

class AddAdsBloc extends Bloc<AddAdsEvent, AddAdsState> {
  final AddAdvertisementUseCase addAdvertisementUseCase;
  final GetSignedInUserUseCase getSignedInUser;

  AddAdsBloc({
    required this.addAdvertisementUseCase,
    required this.getSignedInUser,
  }) : super(AddAdsInitial()) {
    on<AddAdsRequestedEvent>(
      (event, emit) async {
        emit(AddAdsInProgress());

        final result = await getSignedInUser.call(NoParams());
        late User? user;
        result.fold((l) => null, (r) => user = r);

        final failureOrSuccess =
            await addAdvertisementUseCase(AddAdvertisementParams(
          owner: user?.userInfo.id ?? '',
          advertisingTitle: event.advertisingTitle,
          advertisingStartDate: event.advertisingStartDate,
          advertisingEndDate: event.advertisingEndDate,
          advertisingDescription: event.advertisingDescription,
          image: event.image,
          advertisingYear: event.advertisingYear,
          advertisingLocation: event.advertisingLocation,
          advertisingPrice: event.advertisingPrice,
          advertisingType: event.advertisingType,
          advertisingImageList: event.advertisingImageList,
          video: event.video,
          purchasable: event.purchasable,
          type: event.type,
          category: event.category,
          color: event.color,
          guarantee: event.guarantee,
          contactNumber: event.contactNumber,
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
