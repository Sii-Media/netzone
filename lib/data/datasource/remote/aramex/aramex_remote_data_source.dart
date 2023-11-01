import 'package:dio/dio.dart';
import 'package:netzoon/data/models/aramex/create_pickup_input_data_model.dart';
import 'package:netzoon/data/models/aramex/create_pickup_response_model.dart';
import 'package:netzoon/data/models/aramex/create_shipment_input_data_model.dart';
import 'package:netzoon/data/models/aramex/create_shipment_response_model.dart';
import 'package:retrofit/http.dart';

part 'aramex_remote_data_source.g.dart';

abstract class AramexRemoteDataSource {
  Future<CreateShipmentResponseModel> createShipments(
      {CreateShipmentInputDataModel? createShipmentInputDataModel});

  Future<CreatePickUpResponseModel> createPickUp(
      {CreatePickUpInputDataModel? createPickUpInputDataModel});
}

@RestApi(
    baseUrl:
        'https://ws.sbx.aramex.net/ShippingAPI.V2/Shipping/Service_1_0.svc/json')
abstract class AramexRemoteDataSourceImpl implements AramexRemoteDataSource {
  factory AramexRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _AramexRemoteDataSourceImpl(dio,
        baseUrl:
            'https://ws.sbx.aramex.net/ShippingAPI.V2/Shipping/Service_1_0.svc/json');
  }

  @override
  @POST('/CreateShipments')
  Future<CreateShipmentResponseModel> createShipments(
      {@Body() CreateShipmentInputDataModel? createShipmentInputDataModel});

  @override
  @POST('/CreatePickup')
  Future<CreatePickUpResponseModel> createPickUp(
      {@Body() CreatePickUpInputDataModel? createPickUpInputDataModel});
}
