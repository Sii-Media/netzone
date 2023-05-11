import 'package:dio/dio.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:retrofit/http.dart';

part 'ads_remote_data_source.g.dart';

abstract class AdvertismentRemotDataSource {
  Future<AdvertisingModel> getAllAdvertisment();
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class AdvertismentRemotDataSourceImpl
    implements AdvertismentRemotDataSource {
  factory AdvertismentRemotDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _AdvertismentRemotDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/advertisements')
  Future<AdvertisingModel> getAllAdvertisment();
}
