import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/advertisements/entities/advertising.dart';
import 'package:netzoon/domain/core/error/failures.dart';

abstract class AdvertismentRepository {
  Future<Either<Failure, Advertising>> getAllAds();
}
