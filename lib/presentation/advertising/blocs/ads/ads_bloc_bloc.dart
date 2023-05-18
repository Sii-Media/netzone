import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/advertisements/entities/advertisement.dart';
import 'package:netzoon/domain/advertisements/usercases/get_ads_by_type_use_case.dart';
import 'package:netzoon/domain/advertisements/usercases/get_advertisements_usecase.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'ads_bloc_event.dart';
part 'ads_bloc_state.dart';

class AdsBlocBloc extends Bloc<AdsBlocEvent, AdsBlocState> {
  final GetAdvertismentsUseCase getAdvertismentsUseCase;
  final GetAdsByTypeUseCase getAdsByTypeUseCase;
  AdsBlocBloc({
    required this.getAdvertismentsUseCase,
    required this.getAdsByTypeUseCase,
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
  }
}
