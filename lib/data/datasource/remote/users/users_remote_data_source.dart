import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../../../injection_container.dart';
import '../../../models/auth/user_info/user_info_model.dart';

part 'users_remote_data_source.g.dart';

abstract class UsersRemoteDataSource {
  Future<List<UserInfoModel>> getUsersList(String userType);
}

@RestApi(baseUrl: baseUrl)
abstract class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  factory UsersRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _UsersRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET('/user/getUserByType')
  Future<List<UserInfoModel>> getUsersList(
    @Part() String userType,
  );
}
