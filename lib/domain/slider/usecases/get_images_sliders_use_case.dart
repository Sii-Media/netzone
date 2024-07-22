import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/slider/entities/images_slider_response.dart';
import 'package:netzoon/domain/slider/repositories/slider_repository.dart';

class GetImagesSlidersUseCase extends UseCase<ImagesSliderResponse, NoParams> {
  final SliderRepository sliderRepository;

  GetImagesSlidersUseCase({required this.sliderRepository});
  @override
  Future<Either<Failure, ImagesSliderResponse>> call(NoParams params) {
    return sliderRepository.getImagesSliders();
  }
}
