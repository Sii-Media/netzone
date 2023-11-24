part of 'local_company_bloc.dart';

abstract class LocalCompanyState extends Equatable {
  const LocalCompanyState();

  @override
  List<Object> get props => [];
}

class LocalCompanyInitial extends LocalCompanyState {}

class LocalCompanyInProgress extends LocalCompanyState {}

class LocalCompanySuccess extends LocalCompanyState {
  final List<LocalCompany> localCompanies;

  const LocalCompanySuccess({required this.localCompanies});
}

class LocalCompanyProductsSuccess extends LocalCompanyState {
  final List<CategoryProducts> products;

  const LocalCompanyProductsSuccess({required this.products});
}

class LocalCompanyFailure extends LocalCompanyState {
  final String message;

  const LocalCompanyFailure({required this.message});
}

class GetLocalCompaniesSuccess extends LocalCompanyState {
  final List<UserInfo> companies;

  const GetLocalCompaniesSuccess({required this.companies});
}

class GetCompanyServiceSuccess extends LocalCompanyState {
  final List<CompanyService> services;

  const GetCompanyServiceSuccess({required this.services});
}

class AddCompanyServiceSuccess extends LocalCompanyState {
  final String message;

  const AddCompanyServiceSuccess({required this.message});
}

class RateCompanyServiceInProgress extends LocalCompanyState {}

class RateCompanyServiceFailure extends LocalCompanyState {
  final String message;

  const RateCompanyServiceFailure({required this.message});
}

class RateCompanyServiceSuccess extends LocalCompanyState {
  final String message;

  const RateCompanyServiceSuccess({required this.message});
}

class EditCompanyServiceInProgress extends LocalCompanyState {}

class EditCompanyServiceFailure extends LocalCompanyState {
  final String message;

  const EditCompanyServiceFailure({required this.message});
}

class EditCompanyServiceSuccess extends LocalCompanyState {
  final String message;

  const EditCompanyServiceSuccess({required this.message});
}

class DeleteCompanyServiceInProgress extends LocalCompanyState {}

class DeleteCompanyServiceFailure extends LocalCompanyState {
  final String message;

  const DeleteCompanyServiceFailure({required this.message});
}

class DeleteCompanyServiceSuccess extends LocalCompanyState {
  final String message;

  const DeleteCompanyServiceSuccess({required this.message});
}

class GetServicesCategoriesInProgress extends LocalCompanyState {}

class GetServicesCategoriesFailure extends LocalCompanyState {
  final String message;

  const GetServicesCategoriesFailure({required this.message});
}

class GetServicesCategoriesSuccess extends LocalCompanyState {
  final List<ServiceCategory> servicesCategories;

  const GetServicesCategoriesSuccess({required this.servicesCategories});
}

class GetServicesByCategoryInProgress extends LocalCompanyState {}

class GetServicesByCategoryFailure extends LocalCompanyState {
  final String message;

  const GetServicesByCategoryFailure({required this.message});
}

class GetServicesByCategorySuccess extends LocalCompanyState {
  final ServiceCategory servicesCategories;

  const GetServicesByCategorySuccess({required this.servicesCategories});
}
