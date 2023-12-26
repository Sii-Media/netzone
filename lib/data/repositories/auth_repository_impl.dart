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
import 'package:netzoon/injection_container.dart';

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
    bool? isFreeZoon,
    bool? isService,
    bool? isSelectable,
    String? freezoneCity,
    required String country,
    String? secondMobile,
    String? thirdMobile,
    String? subcategory,
    required String? address,
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
    required String? city,
    String? addressDetails,
    int? floorNum,
    String? locationType,
    required String? contactName,
    bool? withAdd,
    String? mainAccount,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        print('aaaaaaaaaaa');
        print(withAdd);
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
          MapEntry('contactName', contactName ?? ""),
          MapEntry('city', city ?? ''),
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
        if (isFreeZoon != null) {
          formData.fields.add(
            MapEntry('isFreeZoon', isFreeZoon.toString()),
          );
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

        if (addressDetails != null) {
          formData.fields
              .add(MapEntry('addressDetails', addressDetails.toString()));
        }
        if (floorNum != null) {
          formData.fields.add(MapEntry('floorNum', floorNum.toString()));
        }
        if (locationType != null) {
          formData.fields
              .add(MapEntry('locationType', locationType.toString()));
        }
        if (withAdd != null) {
          formData.fields.add(MapEntry('withAdd', withAdd.toString()));
        }
        if (mainAccount != null) {
          formData.fields.add(MapEntry('mainAccount', mainAccount));
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
          // String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'tradeLicensePhoto',
            await MultipartFile.fromFile(
              tradeLicensePhoto.path,
              filename: tradeLicensePhoto.path.split('/').last,
              contentType: MediaType('application', 'pdf'),
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

        Response response =
            await dio.post('$baseUrl/user/register', data: formData);

        if (response.statusCode == 201) {
          final UserModel user = UserModel.fromJson(response.data!);

          if (withAdd == null || withAdd == false) {
            local.signInUser(user);
          }

          return Right(user.toDomain());
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
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
    String? secondeMobile,
    String? thirdMobile,
    File? profilePhoto,
    File? coverPhoto,
    String? bio,
    String? description,
    String? website,
    String? link,
    String? slogn,
    String? address,
    required String contactName,
    String? userType,
    String? city,
    String? addressDetails,
    File? frontIdPhoto,
    File? backIdPhoto,
    File? tradeLicensePhoto,
    File? deliveryPermitPhot,
    int? floorNum,
    String? locationType,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'username': username,
          'email': email,
          'firstMobile': firstMobile,
          'contactName': contactName,
        });
        if (secondeMobile != null) {
          formData.fields.add(MapEntry('secondMobile', secondeMobile));
        }
        if (thirdMobile != null) {
          formData.fields.add(MapEntry('thirdMobile', thirdMobile));
        }
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
        if (address != null) {
          formData.fields.add(MapEntry('address', address));
        }
        if (userType != null) {
          formData.fields.add(MapEntry('userType', userType));
        }
        if (city != null) {
          formData.fields.add(MapEntry('city', city));
        }
        if (addressDetails != null) {
          formData.fields.add(MapEntry('addressDetails', addressDetails));
        }
        if (floorNum != null) {
          formData.fields.add(MapEntry('floorNum', floorNum.toString()));
        }
        if (locationType != null) {
          formData.fields.add(MapEntry('locationType', locationType));
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
        if (coverPhoto != null) {
          String fileName = coverPhoto.path.split('/').last;
          formData.files.add(
            MapEntry(
              'coverPhoto',
              await MultipartFile.fromFile(
                coverPhoto.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }
        if (frontIdPhoto != null) {
          String fileName = frontIdPhoto.path.split('/').last;
          formData.files.add(
            MapEntry(
              'frontIdPhoto',
              await MultipartFile.fromFile(
                frontIdPhoto.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }
        if (backIdPhoto != null) {
          String fileName = backIdPhoto.path.split('/').last;
          formData.files.add(
            MapEntry(
              'backIdPhoto',
              await MultipartFile.fromFile(
                backIdPhoto.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }
        if (tradeLicensePhoto != null) {
          String fileName = tradeLicensePhoto.path.split('/').last;
          formData.files.add(
            MapEntry(
              'tradeLicensePhoto',
              await MultipartFile.fromFile(
                tradeLicensePhoto.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }
        if (deliveryPermitPhot != null) {
          String fileName = deliveryPermitPhot.path.split('/').last;
          formData.files.add(
            MapEntry(
              'deliveryPermitPhot',
              await MultipartFile.fromFile(
                deliveryPermitPhot.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ),
          );
        }

        Response response = await dio.put(
            'https://back.netzoon.com/user/editUser/$userId',
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
                  userType: user.userInfo.userType ?? userType,
                  firstMobile: firstMobile,
                  secondeMobile: secondeMobile ?? user.userInfo.secondeMobile,
                  thirdMobile: thirdMobile ?? user.userInfo.thirdMobile,
                  profilePhoto: profilePhoto != null
                      ? profilePhoto.path
                      : user.userInfo.profilePhoto,
                  isFreeZoon: user.userInfo.isFreeZoon,
                  deliverable: user.userInfo.deliverable,
                  id: user.userInfo.id,
                  address: user.userInfo.address ?? address,
                  contactName: user.userInfo.contactName ?? contactName,
                  addressDetails:
                      addressDetails ?? user.userInfo.addressDetails,
                  bio: bio ?? user.userInfo.bio,
                  city: city ?? user.userInfo.city,
                  country: user.userInfo.country,
                  floorNum: floorNum ?? user.userInfo.floorNum,
                  locationType: locationType ?? user.userInfo.locationType,
                  link: link ?? user.userInfo.link,
                  description: description ?? user.userInfo.description,
                  slogn: slogn ?? user.userInfo.slogn,
                  website: website ?? user.userInfo.website,
                ));
          }
          print(updatedUser.toDomain().userInfo.userType);
          local.signInUser(updatedUser);

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

  @override
  Future<Either<Failure, String>> deleteAccount(
      {required String userId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await authRemoteDataSource.deleteAccount(userId);
        return Right(result);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> oAuthSign(
      {required String email,
      String? username,
      String? userType,
      String? firstMobile,
      bool? isFreeZoon,
      bool? isService,
      bool? isSelectable,
      String? freezoneCity,
      String? country,
      String? secondMobile,
      String? thirdMobile,
      String? subcategory,
      String? address,
      int? companyProductsNumber,
      String? sellType,
      String? toCountry,
      bool? deliverable,
      String? profilePhoto,
      File? coverPhoto,
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
      String? city,
      String? addressDetails,
      int? floorNum,
      String? locationType,
      String? contactName}) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();

        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('email', email),
        ]);
        if (username != null) {
          formData.fields.add(
            MapEntry('username', username),
          );
        }
        if (userType != null) {
          formData.fields.add(
            MapEntry('userType', userType),
          );
        }
        if (firstMobile != null) {
          formData.fields.add(
            MapEntry('firstMobile', firstMobile),
          );
        }
        if (isFreeZoon != null) {
          formData.fields.add(
            MapEntry('isFreeZoon', isFreeZoon.toString()),
          );
        }
        if (deliverable != null) {
          formData.fields.add(
            MapEntry('deliverable', deliverable.toString()),
          );
        }

        if (secondMobile != null) {
          formData.fields.add(
            MapEntry('secondMobile', secondMobile),
          );
        }
        if (thirdMobile != null) {
          formData.fields.add(
            MapEntry('thirdMobile', thirdMobile),
          );
        }
        if (address != null) {
          formData.fields.add(
            MapEntry('address', address),
          );
        }
        if (subcategory != null) {
          formData.fields.add(
            MapEntry('subcategory', subcategory),
          );
        }
        if (sellType != null) {
          formData.fields.add(
            MapEntry('sellType', sellType),
          );
        }
        if (toCountry != null) {
          formData.fields.add(
            MapEntry('toCountry', toCountry),
          );
        }
        if (country != null) {
          formData.fields.add(
            MapEntry('country', country),
          );
        }
        if (bio != null) {
          formData.fields.add(
            MapEntry('bio', bio),
          );
        }
        if (description != null) {
          formData.fields.add(
            MapEntry('description', description),
          );
        }
        if (website != null) {
          formData.fields.add(
            MapEntry('website', website),
          );
        }
        if (profilePhoto != null) {
          formData.fields.add(
            MapEntry('profilePhoto', profilePhoto),
          );
        }
        if (isThereWarehouse != null) {
          formData.fields.add(
            MapEntry('isThereWarehouse', isThereWarehouse.toString()),
          );
        }
        if (isThereFoodsDelivery != null) {
          formData.fields.add(
            MapEntry('isThereFoodsDelivery', isThereFoodsDelivery.toString()),
          );
        }
        if (deliveryType != null) {
          formData.fields.add(
            MapEntry('deliveryType', deliveryType),
          );
        }
        if (contactName != null) {
          formData.fields.add(
            MapEntry('contactName', contactName),
          );
        }
        if (city != null) {
          formData.fields.add(
            MapEntry('city', city),
          );
        }

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

        if (addressDetails != null) {
          formData.fields
              .add(MapEntry('addressDetails', addressDetails.toString()));
        }
        if (floorNum != null) {
          formData.fields.add(MapEntry('floorNum', floorNum.toString()));
        }
        if (locationType != null) {
          formData.fields
              .add(MapEntry('locationType', locationType.toString()));
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
          // String fileName = 'image.jpg';
          formData.files.add(MapEntry(
            'tradeLicensePhoto',
            await MultipartFile.fromFile(
              tradeLicensePhoto.path,
              filename: tradeLicensePhoto.path.split('/').last,
              contentType: MediaType('application', 'pdf'),
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

        Response response = await dio
            .post('https://back.netzoon.com/user/oauth', data: formData);

        if (response.statusCode == 201) {
          final UserModel user = UserModel.fromJson(response.data!);
          print(user);
          local.signInUser(user);

          return Right(user.toDomain());
        } else {
          print(response);
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      print(e);
      return Left(CredintialFailure());
    }
  }
}
