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
  final List<CategoryProducts> categoryProducts;

  const LocalCompanyProductsSuccess({required this.categoryProducts});
}

class LocalCompanyFailure extends LocalCompanyState {
  final String message;

  const LocalCompanyFailure({required this.message});
}
