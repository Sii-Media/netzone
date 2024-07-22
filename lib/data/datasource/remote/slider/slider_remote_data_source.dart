import 'package:dio/dio.dart';
import 'package:netzoon/data/models/slider/image_slider_response_model.dart';
import 'package:netzoon/injection_container.dart';
import 'package:retrofit/http.dart';

part 'slider_remote_data_source.g.dart';

abstract class SliderRemoteDataSource {
  Future<ImageSliderResponseModel> getImagesSliders();
}

@RestApi(baseUrl: baseUrl)
abstract class SliderRemoteDataSourceImpl extends SliderRemoteDataSource {
  factory SliderRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _SliderRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/dynamic-sliders')
  Future<ImageSliderResponseModel> getImagesSliders();
}
