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
  final int price;
  final File? image;

  const AddCompanyServiceEvent({
    required this.title,
    required this.description,
    required this.price,
    this.image,
  });
}

class GetCompanyServicesEvent extends LocalCompanyEvent {}

class GetCompanyServicesByIdEvent extends LocalCompanyEvent {
  final String id;

  const GetCompanyServicesByIdEvent({required this.id});
}
