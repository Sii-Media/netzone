part of 'local_company_bloc.dart';

abstract class LocalCompanyEvent extends Equatable {
  const LocalCompanyEvent();

  @override
  List<Object> get props => [];
}

class GetAllLocalCompaniesEvent extends LocalCompanyEvent {}

class GetLocalCompanyProductsEvent extends GetAllLocalCompaniesEvent {
  final String id;

  GetLocalCompanyProductsEvent({required this.id});
}
