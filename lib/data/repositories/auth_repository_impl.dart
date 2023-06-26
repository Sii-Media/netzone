import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:netzoon/data/core/utils/network/network_info.dart';
import 'package:netzoon/data/datasource/local/auth/auth_local_data_source.dart';
import 'package:netzoon/data/datasource/remote/auth/auth_remote_datasource.dart';
import 'package:netzoon/data/models/auth/otp_login/otp_login_response_model.dart';
import 'package:netzoon/data/models/auth/user/user_model.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/auth/repositories/auth_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDatasource local;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource,
      required this.local,
      required this.networkInfo});
  @override
  Future<Either<Failure, User>> signUp({
    required String username,
    required String email,
    required String password,
    required String userType,
    required String firstMobile,
    required bool isFreeZoon,
    File? profilePhoto,
    File? coverPhoto,
    File? banerPhoto,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        FormData formData;
        // final user = await authRemoteDataSource.signUp(
        //     username, email, password, userType, firstMobile, isFreeZoon);
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('IsLoggedIn', true);
        Dio dio = Dio();
        if (profilePhoto != null && coverPhoto != null && banerPhoto != null) {
          formData = FormData.fromMap({
            'username': username,
            'email': email,
            'password': password,
            'userType': userType,
            'firstMobile': firstMobile,
            'isFreeZoon': isFreeZoon,
            'profilePhoto': await MultipartFile.fromFile(profilePhoto.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
            'coverPhoto': await MultipartFile.fromFile(coverPhoto.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
            'bannerPhoto': await MultipartFile.fromFile(banerPhoto.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
          });
        } else if (profilePhoto != null &&
            coverPhoto != null &&
            banerPhoto == null) {
          formData = FormData.fromMap({
            'username': username,
            'email': email,
            'password': password,
            'userType': userType,
            'firstMobile': firstMobile,
            'isFreeZoon': isFreeZoon,
            'profilePhoto': await MultipartFile.fromFile(profilePhoto.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
            'coverPhoto': await MultipartFile.fromFile(coverPhoto.path,
                filename: 'image.jpg', contentType: MediaType('image', 'jpeg')),
          });
        } else {
          return Left(ServerFailure());
        }

        Response response = await dio.post(
            'https://net-zoon.onrender.com/user/register',
            data: formData);

        if (response.statusCode == 201) {
          final UserModel user = UserModel.fromJson(response.data!);

          local.signInUser(user);

          return Right(user.toDomain());
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signIn(
      {required String email, required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.signIn(email, password);
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('IsLoggedIn', true);
        local.signInUser(user);
        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, User>> changeAccount(
      {required String email, required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.changeAccount(email, password);
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('IsLoggedIn', true);
        local.signInUser(user);
        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getSignedInUser() async {
    return right(local.getSignedInUser()?.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    local.logout();
    return right(unit);
  }

  @override
  Future<Either<Failure, bool>> getIsFirstTimeLogged() async {
    return right(local.getIsFirstTimeLogged());
  }

  @override
  Future<Either<Failure, void>> setFirstTimeLogged(bool firstTimeLogged) async {
    return right(local.setFirstTimeLogged(firstTimeLogged));
  }

  @override
  Future<Either<Failure, OtpLoginResponse>> getOtpCode(
      {required String mobileNumber}) async {
    try {
      if (await networkInfo.isConnected) {
        final data = await authRemoteDataSource.getOtpCode(mobileNumber);
        return Right(data.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, OtpLoginResponse>> verifyOtpCode(
      {required String phone,
      required String otp,
      required String hash}) async {
    try {
      if (await networkInfo.isConnected) {
        final data = await authRemoteDataSource.verifyOtpCode(phone, otp, hash);
        return Right(data.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(OTPValidFailure());
    }
  }

  @override
  Future<Either<Failure, String>> editProfile(
      {required String userId,
      required String username,
      required String email,
      required String firstMobile,
      required String secondeMobile,
      required String thirdMobile,
      required File? profilePhoto}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'username': username,
          'email': email,
          'firstMobile': firstMobile,
          'secondMobile': secondeMobile,
          'thirdMobile': thirdMobile,
        });
        if (profilePhoto != null) {
          String fileName = profilePhoto.path.split('/').last;
          formData.files.add(
            MapEntry(
              'profilePhoto',
              await MultipartFile.fromFile(
                profilePhoto.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }

        Response response = await dio.put(
            'https://net-zoon.onrender.com/user/editUser/$userId',
            data: formData);

        if (response.statusCode == 200) {
          final user = local.getSignedInUser();
          late UserModel updatedUser;
          if (user != null) {
            updatedUser = UserModel(
                token: user.token,
                message: user.message,
                userInfo: UserInfoModel(
                  username: username,
                  email: email,
                  password: user.userInfo.password,
                  userType: user.userInfo.userType,
                  firstMobile: firstMobile,
                  secondeMobile: secondeMobile,
                  thirdMobile: thirdMobile,
                  profilePhoto: profilePhoto != null
                      ? profilePhoto.path
                      : user.userInfo.profilePhoto,
                  isFreeZoon: user.userInfo.isFreeZoon,
                  id: user.userInfo.id,
                ));
          }
          await local.signInUser(updatedUser);

          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, UserInfo>> getUserById(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await authRemoteDataSource.getUserById(userId);
        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      {required String userId,
      required String currentPassword,
      required String newPassword}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await authRemoteDataSource.changePassword(
            userId, currentPassword, newPassword);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, UserInfo>> addAcccess(
      {required String email,
      required String username,
      required String password}) async {
    try {
      if (await networkInfo.isConnected) {
        final user =
            await authRemoteDataSource.addAccount(email, username, password);

        return Right(user.toDomain());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getUserAccounts(
      {required String email}) async {
    try {
      if (await networkInfo.isConnected) {
        final accounts = await authRemoteDataSource.getUserAccounts(email);
        return Right(accounts.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }
}
