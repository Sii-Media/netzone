import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/slider/entities/images_slider_response.dart';

abstract class SliderRepository {
  Future<Either<Failure, ImagesSliderResponse>> getImagesSliders();
}
