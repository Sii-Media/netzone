import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AuthRepository {
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
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> oAuthSign({
    required String email,
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
    String? contactName,
  });

  Future<Either<Failure, String>> deleteAccount({
    required String userId,
  });

  Future<Either<Failure, User>> changeAccount({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserInfo>> getUserById({
    required String userId,
  });

  Future<Either<Failure, User?>> getSignedInUser();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, String>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> getIsFirstTimeLogged();
  Future<Either<Failure, void>> setFirstTimeLogged(bool firstTimeLogged);

  Future<Either<Failure, OtpLoginResponse>> getOtpCode({
    required String mobileNumber,
  });
  Future<Either<Failure, OtpLoginResponse>> verifyOtpCode({
    required String phone,
    required String otp,
    required String hash,
  });

  Future<Either<Failure, String>> editProfile({
    required String userId,
    required String username,
    required String email,
    required String firstMobile,
    String? secondeMobile,
    String? thirdMobile,
    required File? profilePhoto,
    required String contactName,
    File? coverPhoto,
    String? bio,
    String? description,
    String? website,
    String? link,
    String? slogn,
    String? address,
    String? userType,
    String? city,
    String? addressDetails,
    File? frontIdPhoto,
    File? backIdPhoto,
    File? tradeLicensePhoto,
    File? deliveryPermitPhot,
  });

  Future<Either<Failure, UserInfo>> addAcccess({
    required String email,
    required String username,
    required String password,
  });

  Future<Either<Failure, List<UserInfo>>> getUserAccounts({
    required String email,
  });

  Future<Either<Failure, List<UserInfo>>> getUserFollowings({
    required String userId,
  });

  Future<Either<Failure, List<UserInfo>>> getUserFollowers({
    required String userId,
  });
  Future<Either<Failure, String>> toggleFollow({
    required String currentUserId,
    required String otherUserId,
  });

  // Future<Either<Failure, RatingResponse>> getUserTotalRating({
  //   required String id,
  // });

  Future<Either<Failure, String>> rateUser({
    required String id,
    required double rating,
    required String userId,
  });

  Future<Either<Failure, String>> addVisitor({
    required String userId,
    required String viewerUserId,
  });

  Future<Either<Failure, List<UserInfo>>> getVisitors({
    required String id,
  });

  Future<Either<Failure, List<UserInfo>>> getAllUsers({
    required String? name,
  });

  Future<Either<Failure, String>> forgetPassword({
    required String email,
  });

  Future<Either<Failure, String>> resetPassword({
    required String password,
    required String token,
  });
}
