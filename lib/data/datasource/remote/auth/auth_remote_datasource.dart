import 'package:dio/dio.dart';
import 'package:netzoon/data/models/auth/otp_login/otp_login_response_model.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
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

  Future<UserModel> changeAccount(
    final String email,
    final String password,
  );

  Future<String> changePassword(
    final String userId,
    final String currentPassword,
    final String newPassword,
  );

  Future<OtpLoginResponseModel> getOtpCode(
    final String phone,
  );

  Future<OtpLoginResponseModel> verifyOtpCode(
    final String phone,
    final String otp,
    final String hash,
  );

  Future<UserInfoModel> getUserById(final String userId);

  Future<UserInfoModel> addAccount(
      final String email, final String username, final String password);

  Future<List<UserInfoModel>> getUserAccounts(final String email);

  // Future<UserInfoModel> editProfile(
  //     String userId,
  //     String username,
  //     String email,
  //     String firstMobile,
  //     String secondeMobile,
  //     String thirdMobile,
  //     File? profilePhoto);

  Future<List<UserInfoModel>> getUserFollowings(final String userId);
  Future<List<UserInfoModel>> getUserFollowers(final String userId);
  Future<String> toggleFollow(
    final String currentUserId,
    final String otherUserId,
  );

  Future<String> rateUser(
    final String id,
    final double rating,
    final String userId,
  );

  Future<String> addVisitor(
    final String userId,
    final String viewerUserId,
  );

  Future<List<UserInfoModel>> getVisitors(
    final String id,
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

  @override
  @POST('/user/changeAccount')
  Future<UserModel> changeAccount(
    @Part() String email,
    @Part() String password,
  );

  @override
  @POST('/user/otpLogin')
  Future<OtpLoginResponseModel> getOtpCode(
    @Part() String phone,
  );

  @override
  @POST('/user/verifyOtpLogin')
  Future<OtpLoginResponseModel> verifyOtpCode(
    @Part() String phone,
    @Part() String otp,
    @Part() String hash,
  );

  @override
  @GET('/user/getUser/{userId}')
  Future<UserInfoModel> getUserById(
    @Path('userId') String userId,
  );

  @override
  @PUT('/user/password/{userId}')
  Future<String> changePassword(
    @Path('userId') String userId,
    @Part() String currentPassword,
    @Part() String newPassword,
  );

  @override
  @POST('/user/addaccount')
  Future<UserInfoModel> addAccount(
    @Part() String email,
    @Part() String username,
    @Part() String password,
  );

  @override
  @GET('/user/getuseraccounts')
  Future<List<UserInfoModel>> getUserAccounts(
    @Query('email') String email,
  );

  // @override
  // @PUT('/user/editUser/{userId}')
  // @MultiPart()
  // Future<UserInfoModel> editProfile(
  //   @Path('userId') String userId,
  //   @Part(name: 'username') String username,
  //   @Part(name: 'email') String email,
  //   @Part(name: 'firstMobile') String firstMobile,
  //   @Part(name: 'secondMobile') String secondMobile,
  //   @Part(name: 'thirdMobile') String thirdMobile,
  //   @Part(name: 'profilePhoto') File? profilePhoto,
  // );

  @override
  @GET('/user/getUserFollowings/{userId}')
  Future<List<UserInfoModel>> getUserFollowings(
    @Path() String userId,
  );

  @override
  @GET('/user/getUserFollowers/{userId}')
  Future<List<UserInfoModel>> getUserFollowers(
    @Path() String userId,
  );
  @override
  @PUT('/user/toggleFollow/{otherUserId}')
  Future<String> toggleFollow(
      @Part() String currentUserId, @Path() String otherUserId);

  @override
  @POST('/user/{id}/rate')
  Future<String> rateUser(
    @Path('id') String id,
    @Part() double rating,
    @Part() String userId,
  );

  @override
  @POST('/user/{userId}/addvisitor')
  Future<String> addVisitor(
    @Path('userId') String userId,
    @Part() String viewerUserId,
  );

  @override
  @GET('/user/{id}/visitors')
  Future<List<UserInfoModel>> getVisitors(
    @Path('id') String id,
  );
}
