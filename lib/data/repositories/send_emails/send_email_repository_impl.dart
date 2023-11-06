import 'package:netzoon/data/datasource/remote/send_email/send_email_remote_data_sourse.dart';
import 'package:netzoon/domain/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../../domain/send_emails/repositories/send_email_repository.dart';
import '../../core/utils/network/network_info.dart';

class SendEmailRepositoryImpl implements SendEmailRepository {
  final NetworkInfo networkInfo;
  final SendEmailRemoteDataSource sendEmailRemoteDataSource;

  SendEmailRepositoryImpl(
      {required this.networkInfo, required this.sendEmailRemoteDataSource});
  @override
  Future<Either<Failure, String>> sendEmail(
      {required String name,
      required String email,
      required String subject,
      required String message}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await sendEmailRemoteDataSource.sendEmail(
            name, email, subject, message);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailOnPayment(
      {required String toName,
      required String toEmail,
      required String userMobile,
      required String productsNames,
      required String grandTotal,
      required String serviceFee}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await sendEmailRemoteDataSource.sendEmailOnPayment(
            toName, toEmail, userMobile, productsNames, grandTotal, serviceFee);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailOnDelivery({
    required String toName,
    required String toEmail,
    required String mobile,
    required String city,
    required String addressDetails,
    required String floorNum,
    required String subject,
    required String from,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await sendEmailRemoteDataSource.sendEmailOnDelivery(
          toName: toName,
          toEmail: toEmail,
          mobile: mobile,
          city: city,
          addressDetails: addressDetails,
          floorNum: floorNum,
          subject: subject,
          from: from,
        );
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendEmailBalance(
      {required String fullName,
      required String email,
      required double balance,
      required String accountName,
      required String bankName,
      required String iban,
      required String phoneNumber}) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await sendEmailRemoteDataSource.sendEmailBalance(
            fullName, email, balance, accountName, bankName, iban, phoneNumber);
        return Right(response);
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
