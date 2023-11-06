import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:netzoon/data/datasource/remote/real_estate/real_estate_remote_data_source.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/data/models/real_estate/real_estate_model.dart';
import 'package:netzoon/domain/auth/entities/user_info.dart';
import 'package:netzoon/domain/categories/entities/real_estate/real_estate.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/categories/repositories/real_estate_repository.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/network/network_info.dart';

class RealEstateRepositoryImpl implements RealEstateRepository {
  final NetworkInfo networkInfo;
  final RealEstateRemoteDataSource realEstateRemoteDataSource;
  RealEstateRepositoryImpl({
    required this.networkInfo,
    required this.realEstateRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<RealEstate>>> getAllRealEstates({
    required String country,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final realEstates =
            await realEstateRemoteDataSource.getAllRealEstates(country);
        return Right(realEstates.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserInfo>>> getRealEstateCompanies({
    required String country,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final realEstateCompanies =
            await realEstateRemoteDataSource.getRealEstateCompanies(country);

        return Right(realEstateCompanies.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<RealEstate>>> getcompanyRealEstates(
      {required String id}) async {
    try {
      if (await networkInfo.isConnected) {
        final realEstates =
            await realEstateRemoteDataSource.getCompanyRealEstates(id);
        return Right(realEstates.map((e) => e.toDomain()).toList());
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> addRealEstate({
    required String createdBy,
    required String title,
    required File image,
    required String description,
    required int price,
    required int area,
    required String location,
    required int bedrooms,
    required int bathrooms,
    List<String>? amenities,
    List<XFile>? realestateimages,
    required String country,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        Dio dio = Dio();
        FormData formData = FormData();
        formData.fields.addAll([
          MapEntry('createdBy', createdBy),
          MapEntry('title', title),
          MapEntry('description', description),
          MapEntry('price', price.toString()),
          MapEntry('area', area.toString()),
          MapEntry('location', location),
          MapEntry('bedrooms', bedrooms.toString()),
          MapEntry('bathrooms', bathrooms.toString()),
          MapEntry('country', country),
        ]);
        if (amenities != null && amenities.isNotEmpty) {
          formData.fields.add(MapEntry('amenities', amenities.toString()));
        }
        String fileName = 'image.jpg';
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
        if (realestateimages != null && realestateimages.isNotEmpty) {
          for (int i = 0; i < realestateimages.length; i++) {
            String fileName = 'image$i.jpg';
            File file = File(realestateimages[i].path);
            formData.files.add(MapEntry(
              'realestateimages',
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType('image', 'jpeg'),
              ),
            ));
          }
        }
        Response response = await dio.post(
            'https://www.back.netzoon.com//real-estate/add-real-estate',
            data: formData);
        if (response.statusCode == 201) {
          return Right(response.data);
        } else {
          return Left(ServerFailure());
        }
      } else {
        return Left(OfflineFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
