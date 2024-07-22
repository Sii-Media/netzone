import 'package:dartz/dartz.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/remote/slider/slider_remote_data_source.dart';
import 'package:netzoon/data/models/slider/image_slider_response_model.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:netzoon/domain/slider/entities/images_slider_response.dart';
import 'package:netzoon/domain/slider/repositories/slider_repository.dart';

class SliderRepositoryImpl implements SliderRepository {
  final NetworkInfo networkInfo;
  final SliderRemoteDataSource sliderRemoteDataSource;
  SliderRepositoryImpl({
    required this.networkInfo,
    required this.sliderRemoteDataSource,
  });
  @override
  Future<Either<Failure, ImagesSliderResponse>> getImagesSliders() async {
    try {
      if (await networkInfo.isConnected) {
        final imagesSliders = await sliderRemoteDataSource.getImagesSliders();
        return Right(imagesSliders.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
