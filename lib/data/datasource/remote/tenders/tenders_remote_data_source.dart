import 'package:dio/dio.dart';
import 'package:netzoon/data/models/tenders/tenders_items/tendres_item_response_model.dart';
import 'package:netzoon/data/models/tenders/tenders_response/tender_response_model.dart';
import 'package:retrofit/http.dart';

part 'tenders_remote_data_source.g.dart';

abstract class TendersRemoteDataSource {
  Future<TenderResponseModel> getTendersCategories();
  Future<TendersItemResponseModel> getTendersItemsByMin(
    final String category,
  );
  Future<TendersItemResponseModel> getTendersItemsByMax(
    final String category,
  );
  Future<TendersItemResponseModel> getTendersItems();
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class TendersRemoteDataSourceImpl implements TendersRemoteDataSource {
  factory TendersRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _TendersRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/tenders')
  Future<TenderResponseModel> getTendersCategories();

  @override
  @GET('/tenders/itemsbyminprice')
  Future<TendersItemResponseModel> getTendersItemsByMin(
    @Part() String category,
  );

  @override
  @GET('/tenders/itemsbymaxprice')
  Future<TendersItemResponseModel> getTendersItemsByMax(
    @Part() String category,
  );

  @override
  @GET('/tenders/alltendersItems')
  Future<TendersItemResponseModel> getTendersItems();
}
