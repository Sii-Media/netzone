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
