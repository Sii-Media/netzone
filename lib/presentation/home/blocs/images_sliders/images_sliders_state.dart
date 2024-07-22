part of 'images_sliders_bloc.dart';

class ImagesSlidersState extends Equatable {
  const ImagesSlidersState();

  @override
  List<Object> get props => [];
}

class ImagesSlidersInitial extends ImagesSlidersState {}

class GetImagesSlidersInProgress extends ImagesSlidersState {}

class GetImagesSlidersFailure extends ImagesSlidersState {
  final String message;

  const GetImagesSlidersFailure({required this.message});
}

class GetImagesSlidersSuccess extends ImagesSlidersState {
  final ImagesSliderResponse sliders;

  const GetImagesSlidersSuccess({required this.sliders});
}
