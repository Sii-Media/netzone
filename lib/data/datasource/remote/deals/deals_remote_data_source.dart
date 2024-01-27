import 'package:dio/dio.dart';
import 'package:netzoon/data/models/deals/deals_items/deals_items_response_model.dart';
import 'package:netzoon/data/models/deals/deals_response/deals_response_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';
import '../../../models/deals/deals_items/deals_item_model.dart';

part 'deals_remote_data_source.g.dart';

abstract class DealsRemoteDataSource {
  Future<DealsResponseModel> getDealsCategories();
  Future<DealsItemsResponseModel> getDealsByCategory(
    final String country,
    final String category,
    String? companyName,
    int? minPrice,
    int? maxPrice,
  );
  Future<DealsItemsResponseModel> getDealsItems(String country);

  Future<DealsItemsModel> getDealById(String id);

  Future<String> deleteDeal(String id);
  Future<String> savePurchDeal(
      String userId, String buyerId, String deal, double grandTotal);

  Future<List<DealsItemsModel>> getUserDeals(String userId);
}

@RestApi(baseUrl: baseUrl)
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
    @Query('country') String country,
    @Query('category') String category,
    @Query('companyName') String? companyName,
    @Query('minPrice') int? minPrice,
    @Query('maxPrice') int? maxPrice,
  );

  @override
  @GET('/deals/alldealsItems')
  Future<DealsItemsResponseModel> getDealsItems(
    @Query('country') String country,
  );

  @override
  @GET('/deals/{id}')
  Future<DealsItemsModel> getDealById(
    @Path() String id,
  );

  @override
  @DELETE('/deals/{id}')
  Future<String> deleteDeal(
    @Path('id') String id,
  );

  @override
  @GET('/deals/userDeals/{userId}')
  Future<List<DealsItemsModel>> getUserDeals(
    @Path('userId') String userId,
  );

  @override
  @POST('deals/purch/save/{userId}')
  Future<String> savePurchDeal(
    @Path('userId') String userId,
    @Part() String buyerId,
    @Part() String deal,
    @Part() double grandTotal,
  );
}
