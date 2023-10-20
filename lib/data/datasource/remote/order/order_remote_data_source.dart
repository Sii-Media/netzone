
import 'package:dio/dio.dart';
import 'package:netzoon/data/models/order/my_order_model.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';
import '../../../models/order/order_input_model.dart';

part 'order_remote_data_source.g.dart';

abstract class OrderRemoteDataSource {
  Future<List<MyOrderModel>> getUserOrders(
    final String userId,
  );

  Future<MyOrderModel> saveOrder(
    final String userId,
    final List<OrderInputModel> products,
    final String orderStatus,
    final double grandTotal,
  );
}

@RestApi(baseUrl: baseUrl)
abstract class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  factory OrderRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _OrderRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/order/get/{userId}')
  Future<List<MyOrderModel>> getUserOrders(
    @Path('userId') String userId,
  );

  @override
  @POST('/order/save/{userId}')
  Future<MyOrderModel> saveOrder(
    @Path('userId') String userId,
    @Field() List<OrderInputModel> products,
    @Field() String orderStatus,
    @Field() double grandTotal,
  );
}
