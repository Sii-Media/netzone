import 'package:dio/dio.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_items_response_model.dart';
import 'package:netzoon/data/models/deals/deals_response/deals_response_model.dart';
import 'package:retrofit/http.dart';

part 'deals_remote_data_source.g.dart';

abstract class DealsRemoteDataSource {
  Future<DealsResponseModel> getDealsCategories();
  Future<DealsItemsResponseModel> getDealsByCategory(
    final String category,
  );
  Future<DealsItemsResponseModel> getDealsItems();
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class DealsRemoteDataSourceImpl implements DealsRemoteDataSource {
  factory DealsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _DealsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/deals')
  Future<DealsResponseModel> getDealsCategories();

  @override
  @GET('/deals/dealsByCat')
  Future<DealsItemsResponseModel> getDealsByCategory(
    @Part() String category,
  );

  @override
  @GET('/deals/alldealsItems')
  Future<DealsItemsResponseModel> getDealsItems();
}
