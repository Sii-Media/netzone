import 'package:dio/dio.dart';
import 'package:netzoon/data/models/complaints/complaints_response_model.dart';
import 'package:retrofit/http.dart';

part 'complaints_remote_data_source.g.dart';

abstract class ComplaintsRemoteDataSource {
  Future<ComplaintsResponseModel> getComplaints();
  Future<String> addComplaints(
    final String address,
    final String text,
  );
}

@RestApi(baseUrl: 'http://10.0.2.2:5000')
abstract class ComplaintsRemoteDataSourceImpl
    extends ComplaintsRemoteDataSource {
  factory ComplaintsRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _ComplaintsRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/complaints')
  Future<ComplaintsResponseModel> getComplaints();

  @override
  @POST('/complaints')
  Future<String> addComplaints(
    @Part() String address,
    @Part() String text,
  );
}
