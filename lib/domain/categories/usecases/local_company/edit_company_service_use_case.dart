import 'dart:io';

import 'package:netzoon/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:share_plus/share_plus.dart';

import '../../repositories/local_company_reponsitory.dart';

class EditCompanyServiceUseCase
    extends UseCase<String, EditCompanyServiceParams> {
  final LocalCompanyRepository localCompanyRepository;

  EditCompanyServiceUseCase({required this.localCompanyRepository});

  @override
  Future<Either<Failure, String>> call(EditCompanyServiceParams params) {
    return localCompanyRepository.editCompanyService(
      id: params.id,
      title: params.title,
      description: params.description,
      price: params.price,
      image: params.image,
      serviceImageList: params.serviceImageList,
      whatsAppNumber: params.whatsAppNumber,
    );
  }
}

class EditCompanyServiceParams {
  final String id;
  final String title;
  final String description;
  final int? price;
  final File? image;
  final List<File?> serviceImageList;
  final String? whatsAppNumber;

  EditCompanyServiceParams(
      {required this.id,
      required this.title,
      required this.description,
      this.price,
      this.image,
      required this.serviceImageList,
      this.whatsAppNumber});
}
