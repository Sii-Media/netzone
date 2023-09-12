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
    bool? isService,
    bool? isSelectable,
    String? freezoneCity,
    required String country,
    String? secondMobile,
    String? thirdMobile,
    String? subcategory,
    String? address,
    int? companyProductsNumbe,
    String? sellType,
    String? toCountry,
    bool? deliverable,
    File? profilePhoto,
    File? coverPhoto,
    File? banerPhoto,
    File? frontIdPhoto,
    File? backIdPhoto,
    String? bio,
    String? description,
    String? website,
    String? slogn,
    String? link,
    String? title,
    File? tradeLicensePhoto,
    File? deliveryPermitPhoto,
    bool? isThereWarehouse,
    bool? isThereFoodsDelivery,
    String? deliveryType,
    int? deliveryCarsNum,
    int? deliveryMotorsNum,
    double? profitRatio,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        // FormData formData;
        // // final user = await authRemoteDataSource.signUp(
        // //     username, email, password, userType, firstMobile, isFreeZoon);
        // // SharedPreferences preferences = await SharedPreferences.getInstance();
        // // await preferences.setBool('IsLoggedIn', true);
        Dio dio = Dio();

        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('username', username),
          MapEntry('email', email),
          MapEntry('password', password),
          MapEntry('userType', userType),
          MapEntry('firstMobile', firstMobile),
          MapEntry('isFreeZoon', isFreeZoon.toString()),
          MapEntry('deliverable', deliverable.toString()),
          MapEntry('secondMobile', secondMobile ?? ''),
          MapEntry('thirdMobile', thirdMobile ?? ''),
          MapEntry('address', address ?? ''),
          MapEntry('subcategory', subcategory ?? ''),
          MapEntry('companyProductsNumbe', companyProductsNumbe.toString()),
          MapEntry('sellType', sellType ?? ''),
          MapEntry('toCountry', toCountry ?? ''),
          MapEntry('bio', bio ?? ''),
          MapEntry('description', description ?? ''),
          MapEntry('website', website ?? ''),
          MapEntry('country', country),
          MapEntry('isThereWarehouse', isThereWarehouse.toString()),
          MapEntry('isThereFoodsDelivery', isThereFoodsDelivery.toString()),
          MapEntry('deliveryType', deliveryType.toString()),
        ]);
        if (title != null) {
          formData.fields.add(MapEntry('title', title));
        }
        if (freezoneCity != null) {
          formData.fields.add(MapEntry('freezoneCity', freezoneCity));
        }
        if (deliveryCarsNum != null) {
          formData.fields
              .add(MapEntry('deliveryCarsNum', deliveryCarsNum.toString()));
        }
        if (deliveryMotorsNum != null) {
          formData.fields
              .add(MapEntry('deliveryMotorsNum', deliveryMotorsNum.toString()));
        }
        if (isService != null) {
          formData.fields.add(MapEntry('isService', isService.toString()));
        }
        if (isSelectable != null) {
          formData.fields
              .add(MapEntry('isSelectable', isSelectable.toString()));
        }
        if (slogn != null) {
          formData.fields.add(MapEntry('slogn', slogn));
        }
        if (link != null) {
          formData.fields.add(MapEntry('link', link));
        }
        if (profitRatio != null) {
          formData.fields.add(MapEntry('profitRatio', profitRatio.toString()));
        }
        if (profilePhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'profilePhoto',
            await MultipartFile.fromFile(
              profilePhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (coverPhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'coverPhoto',
            await MultipartFile.fromFile(
              coverPhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (banerPhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'bannerPhoto',
            await MultipartFile.fromFile(
              banerPhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (frontIdPhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'frontIdPhoto',
            await MultipartFile.fromFile(
              frontIdPhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (backIdPhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'backIdPhoto',
            await MultipartFile.fromFile(
              backIdPhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }
        if (tradeLicensePhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'tradeLicensePhoto',
            await MultipartFile.fromFile(
              tradeLicensePhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
        }

        if (deliveryPermitPhoto != null) {
          String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'deliveryPermitPhoto',
            await MultipartFile.fromFile(
              deliveryPermitPhoto.path,
              filename: fileName,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
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
  Future<Either<Failure, String>> editProfile({
    required String userId,
    required String username,
    required String email,
    required String firstMobile,
    required String secondeMobile,
    required String thirdMobile,
    required File? profilePhoto,
    String? bio,
    String? description,
    String? website,
    String? link,
    String? slogn,
  }) async {
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
        if (bio != null) {
          formData.fields.add(MapEntry('bio', bio));
        }
        if (description != null) {
          formData.fields.add(MapEntry('description', description));
        }
        if (website != null) {
          formData.fields.add(MapEntry('website', website));
        }
        if (slogn != null) {
          formData.fields.add(MapEntry('slogn', slogn));
        }
        if (link != null) {
          formData.fields.add(MapEntry('link', link));
        }

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
                  deliverable: user.userInfo.deliverable,
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

  @override
  Future<Either<Failure, List<UserInfo>>> getUserFollowers(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final followings = await authRemoteDataSource.getUserFollowers(userId);
        return Right(followings.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getUserFollowings(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final followers = await authRemoteDataSource.getUserFollowings(userId);
        return Right(followers.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, String>> toggleFollow(
      {required String currentUserId, required String otherUserId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result =
            await authRemoteDataSource.toggleFollow(currentUserId, otherUserId);
        await local.toggoleFollow(otherUserId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(CredintialFailure());
    }
  }

  @override
  Future<Either<Failure, String>> rateUser(
      {required String id,
      required double rating,
      required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await authRemoteDataSource.rateUser(id, rating, userId);

        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(RatingFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addVisitor(
      {required String userId, required String viewerUserId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result =
            await authRemoteDataSource.addVisitor(userId, viewerUserId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getVisitors(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final visitors = await authRemoteDataSource.getVisitors(id);
        return Right(visitors.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getAllUsers() async {
    try {
      if (await networkInfo.isConnected) {
        final users = await authRemoteDataSource.getAllUsers();
        return Right(users.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
