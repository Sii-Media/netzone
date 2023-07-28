import 'dart:io';

import 'package:netzoon/domain/categories/repositories/local_company_reponsitory.dart';
import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

class AddCompanyServiceUseCase
    extends UseCase<String, AddCompanyServiceParams> {
  final LocalCompanyRepository localCompanyRepository;

  AddCompanyServiceUseCase({required this.localCompanyRepository});
  @override
  Future<Either<Failure, String>> call(AddCompanyServiceParams params) {
    return localCompanyRepository.addCompanyService(
      title: params.title,
      description: params.description,
      price: params.price,
      owner: params.owner,
      image: params.image,
      serviceImageList: params.serviceImageList,
      whatsAppNumber: params.whatsAppNumber,
    );
  }
}

class AddCompanyServiceParams {
  final String title;
  final String description;
  final int? price;
  final String owner;
  File? image;
  List<XFile>? serviceImageList;
  String? whatsAppNumber;
  AddCompanyServiceParams({
    required this.title,
    required this.description,
    this.price,
    required this.owner,
    this.image,
    this.serviceImageList,
    this.whatsAppNumber,
  });
}
