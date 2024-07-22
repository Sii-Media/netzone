import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/usercases/add_ads_visitor_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/delete_ads_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/edit_ads_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_id_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_type_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/advertisements/usercases/get_user_ads_use_case.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/get_country_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';
import '../../../../domain/core/usecase/usecase.dart';

part 'ads_bloc_event.dart';
part 'ads_bloc_state.dart';

class AdsBlocBloc extends Bloc<AdsBlocEvent, AdsBlocState> {
  final GetAdvertismentsUseCase getAdvertismentsUseCase;
  final GetAdsByTypeUseCase getAdsByTypeUseCase;
  final GetAdsByIdUseCase getAdsByIdUseCase;
  final GetUserAdsUseCase getUserAdsUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  final EditAdsUseCase editAdsUseCase;
  final DeleteAdsUseCase deleteAdsUseCase;
  final AddAdsVisitorUseCase addAdsVisitorUseCase;
  final GetCountryUseCase getCountryUseCase;
  AdsBlocBloc({
    required this.getAdvertismentsUseCase,
    required this.getAdsByTypeUseCase,
    required this.getAdsByIdUseCase,
    required this.getUserAdsUseCase,
    required this.getSignedInUser,
    required this.editAdsUseCase,
    required this.deleteAdsUseCase,
    required this.addAdsVisitorUseCase,
    required this.getCountryUseCase,
  }) : super(AdsBlocInitial()) {
    on<GetAllAdsEvent>(
      (event, emit) async {
        late String country;
        final result = await getCountryUseCase(NoParams());
        result.fold((l) => null, (r) => country = r ?? 'AE');

        emit(AdsBlocInProgress());
        final ads = await getAdvertismentsUseCase(GetAdsParams(
            owner: event.owner,
            priceMax: event.priceMax,
            priceMin: event.priceMin,
            purchasable: event.purchasable,
            year: event.year,
            country: country));

        emit(ads.fold(
            (failure) => AdsBlocFailure(message: mapFailureToString(failure)),
            (ads) => AdsBlocSuccess(ads: ads.advertisement)));
      },
    );
    on<GetUserAdsEvent>((event, emit) async {
      emit(AdsBlocInProgress());

      final ads = await getUserAdsUseCase(event.userId);

      emit(ads.fold(
          (failure) => AdsBlocFailure(message: mapFailureToString(failure)),
          (ads) => AdsBlocSuccess(ads: ads.advertisement)));
    });

    on<GetAdsByType>((event, emit) async {
      emit(AdsBlocInProgress());
      late String country;
      final result = await getCountryUseCase(NoParams());
      result.fold((l) => null, (r) => country = r ?? 'AE');
      final ads = await getAdsByTypeUseCase(
        GetAdsByTypeParams(
            userAdvertisingType: event.userAdvertisingType, country: country),
      );

      emit(ads.fold(
          (failure) => AdsBlocFailure(message: mapFailureToString(failure)),
          (ads) => AdsBlocSuccess(ads: ads.advertisement)));
    });
    on<GetAdsByIdEvent>((event, emit) async {
      emit(AdsBlocInProgress());
      final ads = await getAdsByIdUseCase(event.id);

      emit(
        ads.fold(
          (failure) => AdsBlocFailure(message: mapFailureToString(failure)),
          (ads) => GetAdsByIdSuccess(ads: ads),
        ),
      );
    });
    on<EditAdsEvent>((event, emit) async {
      emit(EditAdsInProgress());
      final ads = await editAdsUseCase(EditAdsParams(
        id: event.id,
        advertisingTitle: event.advertisingTitle,
        advertisingStartDate: event.advertisingStartDate,
        advertisingEndDate: event.advertisingEndDate,
        advertisingDescription: event.advertisingDescription,
        advertisingYear: event.advertisingYear,
        advertisingLocation: event.advertisingLocation,
        advertisingPrice: event.advertisingPrice,
        advertisingType: event.advertisingType,
        purchasable: event.purchasable,
        advertisingImageList: event.advertisingImageList,
        category: event.category,
        color: event.color,
        contactNumber: event.contactNumber,
        guarantee: event.guarantee,
        image: event.image,
        type: event.type,
        video: event.video,
      ));
      emit(
        ads.fold(
          (failure) => EditAdsFailure(
              message: mapFailureToString(failure), failure: failure),
          (message) => EditAdsSuccess(message: message),
        ),
      );
    });
    on<DeleteAdsEvent>((event, emit) async {
      emit(DeleteAdsInProgress());
      final result = await deleteAdsUseCase(event.id);
      emit(
        result.fold(
          (failure) => DeleteAdsFailure(
              message: mapFailureToString(failure), failure: failure),
          (message) => DeleteAdsSuccess(message: message),
        ),
      );
    });
    on<AddAdsVisitorEvent>((event, emit) async {
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      final success = await addAdsVisitorUseCase(AddAdsVisitorParams(
          adsId: event.adsId, viewerUserId: user.userInfo.id));
      success.fold(
          (failure) =>
              emit(AddAdsVisitorFailure(message: mapFailureToString(failure))),
          (message) => emit(AddAdsVisitorSuccess(message: message)));
    });
  }
}
