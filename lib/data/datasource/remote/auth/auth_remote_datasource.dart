import 'package:dio/dio.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:retrofit/http.dart';
import '../../../../injection_container.dart';

part 'auth_remote_datasource.g.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(
    final String username,
    final String email,
    final String password,
    final String userType,
    final String firstMobile,
    final bool isFreeZoon,
  );

  Future<UserModel> signIn(
    final String email,
    final String password,
  );
}

@RestApi(baseUrl: baseUrl)
abstract class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  factory AuthRemoteDataSourceImpl(Dio dio, {required String baseUrl}) {
    dio.options = BaseOptions(
      receiveTimeout: const Duration(seconds: 10),
      connectTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
      headers: {'Content-Type': 'application/json'},
    );
    return _AuthRemoteDataSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @POST('/user/register')
  Future<UserModel> signUp(
    @Part() String username,
    @Part() String email,
    @Part() String password,
    @Part() String userType,
    @Part() String firstMobile,
    @Part() bool isFreeZoon,
  );

  @override
  @POST('/user/signin')
  Future<UserModel> signIn(
    @Part() String email,
    @Part() String password,
  );
}
