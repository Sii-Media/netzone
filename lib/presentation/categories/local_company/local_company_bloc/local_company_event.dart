part of 'local_company_bloc.dart';

abstract class LocalCompanyEvent extends Equatable {
  const LocalCompanyEvent();

  @override
  List<Object> get props => [];
}

class GetAllLocalCompaniesEvent extends LocalCompanyEvent {}

class GetLocalCompanyProductsEvent extends LocalCompanyEvent {
  final String id;

  const GetLocalCompanyProductsEvent({required this.id});
}

class GetLocalCompaniesEvent extends LocalCompanyEvent {
  final String userType;

  const GetLocalCompaniesEvent({required this.userType});
}

class GetLocalProductsEvent extends LocalCompanyEvent {
  final String username;

  const GetLocalProductsEvent({required this.username});
}

class AddCompanyServiceEvent extends LocalCompanyEvent {
  final String title;
  final String description;
  final int? price;
  final File? image;
  final List<XFile>? serviceImageList;
  final String? whatsAppNumber;
  const AddCompanyServiceEvent({
    required this.title,
    required this.description,
    this.price,
    this.image,
    this.serviceImageList,
    this.whatsAppNumber,
  });
}

class GetCompanyServicesEvent extends LocalCompanyEvent {}

class GetCompanyServicesByIdEvent extends LocalCompanyEvent {
  final String id;

  const GetCompanyServicesByIdEvent({required this.id});
}

class RateCompanyServiceEvent extends LocalCompanyEvent {
  final String id;
  final double rating;

  const RateCompanyServiceEvent({required this.id, required this.rating});
}

class EditCompanyServiceEvent extends LocalCompanyEvent {
  final String id;
  final String title;
  final String description;
  final int? price;
  final File? image;
  final List<File?> serviceImageList;
  final String? whatsAppNumber;

  const EditCompanyServiceEvent(
      {required this.id,
      required this.title,
      required this.description,
      this.price,
      this.image,
      required this.serviceImageList,
      this.whatsAppNumber});
}

class DeleteCompanyServiceEvent extends LocalCompanyEvent {
  final String id;

  const DeleteCompanyServiceEvent({required this.id});
}
