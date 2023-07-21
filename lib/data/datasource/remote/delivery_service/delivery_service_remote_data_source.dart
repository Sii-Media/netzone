import 'package:dio/dio.dart';
import 'package:netzoon/data/models/delivery_service/delivery_service_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';

part 'delivery_service_remote_data_source.g.dart';

abstract class DeliveryServiceRemoteDataSource {
  Future<List<DeliveryServiceModel>> getDeliveryCompanyServices(
    String id,
  );
  Future<String> addDeliveryService(
    String title,
    String description,
    String from,
    String to,
    int price,
    String owner,
  );
}

@RestApi(baseUrl: baseUrl)
abstract class DeliveryServiceRemoteDataSourceImpl
    implements DeliveryServiceRemoteDataSource {
  factory DeliveryServiceRemoteDataSourceImpl(Dio dio,
      {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _DeliveryServiceRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/delivery/{id}')
  Future<List<DeliveryServiceModel>> getDeliveryCompanyServices(
    @Path() String id,
  );

  @override
  @POST('/delivery/add-service')
  Future<String> addDeliveryService(
    @Field() String title,
    @Field() String description,
    @Field() String from,
    @Field() String to,
    @Field() int price,
    @Field() String owner,
  );
}
