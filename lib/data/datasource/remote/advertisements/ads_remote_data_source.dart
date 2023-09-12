import 'package:dio/dio.dart';
import 'package:netzoon/data/models/advertisements/advertising/advertising_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';
import '../../../models/advertisements/advertisements/advertiement_model.dart';

part 'ads_remote_data_source.g.dart';

abstract class AdvertismentRemotDataSource {
  Future<AdvertisingModel> getAllAdvertisment(
    String? owner,
    int? priceMin,
    int? priceMax,
    bool? purchasable,
    String? year,
  );
  Future<AdvertisingModel> getUserAds(String userId);

  Future<AdvertisemenetModel> getAdsById(String id);
  Future<AdvertisingModel> getAdvertisementByType(
    final String userAdvertisingType,
  );
  Future<String> deleteAdvertisement(String id);

  Future<String> addAdsVisitor(
    final String adsId,
    final String viewerUserId,
  );
}

@RestApi(baseUrl: baseUrl)
abstract class AdvertismentRemotDataSourceImpl
    implements AdvertismentRemotDataSource {
  factory AdvertismentRemotDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _AdvertismentRemotDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/advertisements')
  Future<AdvertisingModel> getAllAdvertisment(
    @Query('owner') String? owner,
    @Query('priceMin') int? priceMin,
    @Query('priceMax') int? priceMax,
    @Query('purchasable') bool? purchasable,
    @Query('year') String? year,
  );

  @override
  @GET('/advertisements/getbytype/{userAdvertisingType}')
  Future<AdvertisingModel> getAdvertisementByType(
    @Path("userAdvertisingType") String userAdvertisingType,
  );

  @override
  @GET('/advertisements/{id}')
  Future<AdvertisemenetModel> getAdsById(
    @Path() String id,
  );

  @override
  @GET('/advertisements/getUserAds/{userId}')
  Future<AdvertisingModel> getUserAds(
    @Path() String userId,
  );
  @override
  @DELETE('/advertisements/{id}')
  Future<String> deleteAdvertisement(
    @Path('id') String id,
  );

  @override
  @PUT('/advertisements/{adsId}/addvisitor')
  Future<String> addAdsVisitor(
    @Path('adsId') String adsId,
    @Part() String viewerUserId,
  );
}
