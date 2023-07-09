import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_id_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_type_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/advertisements/usercases/get_user_ads_use_case.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';

part 'ads_bloc_event.dart';
part 'ads_bloc_state.dart';

class AdsBlocBloc extends Bloc<AdsBlocEvent, AdsBlocState> {
  final GetAdvertismentsUseCase getAdvertismentsUseCase;
  final GetAdsByTypeUseCase getAdsByTypeUseCase;
  final GetAdsByIdUseCase getAdsByIdUseCase;
  final GetUserAdsUseCase getUserAdsUseCase;
  final GetSignedInUserUseCase getSignedInUser;
  AdsBlocBloc({
    required this.getAdvertismentsUseCase,
    required this.getAdsByTypeUseCase,
    required this.getAdsByIdUseCase,
    required this.getUserAdsUseCase,
    required this.getSignedInUser,
  }) : super(AdsBlocInitial()) {
    on<GetAllAdsEvent>(
      (event, emit) async {
        emit(AdsBlocInProgress());
        final ads = await getAdvertismentsUseCase(NoParams());

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
      final ads = await getAdsByTypeUseCase(
        GetAdsByTypeParams(
          userAdvertisingType: event.userAdvertisingType,
        ),
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
  }
}
