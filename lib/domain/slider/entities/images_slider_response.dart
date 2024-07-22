import 'package:equatable/equatable.dart';

class ImagesSliderResponse extends Equatable {
  final String id;
  final List<String>? mainSlider;
  final List<String>? secondSlider;

  const ImagesSliderResponse(
      {required this.id, required this.mainSlider, required this.secondSlider});

  @override
  List<Object?> get props => [id, mainSlider, secondSlider];
}
