import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/slider/entities/images_slider_response.dart';
import 'package:netzoon/domain/slider/usecases/get_images_sliders_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'images_sliders_event.dart';
part 'images_sliders_state.dart';

class ImagesSlidersBloc extends Bloc<ImagesSlidersEvent, ImagesSlidersState> {
  final GetImagesSlidersUseCase getImagesSlidersUseCase;
  ImagesSlidersBloc({required this.getImagesSlidersUseCase})
      : super(ImagesSlidersInitial()) {
    on<GetImagesSlidersEvent>((event, emit) async {
      emit(GetImagesSlidersInProgress());
      final sliders = await getImagesSlidersUseCase(NoParams());
      emit(sliders.fold(
          (l) => GetImagesSlidersFailure(message: mapFailureToString(l)),
          (r) => GetImagesSlidersSuccess(sliders: r)));
    });
  }
}
