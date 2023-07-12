part of 'real_estate_bloc.dart';

abstract class RealEstateState extends Equatable {
  const RealEstateState();

  @override
  List<Object> get props => [];
}

class RealEstateInitial extends RealEstateState {}

class GetRealEstateInProgress extends RealEstateState {}

class GetRealEstateFailure extends RealEstateState {
  final String message;

  const GetRealEstateFailure({required this.message});
}

class GetAllRealEstatesSuccess extends RealEstateState {
  final List<RealEstate> realEstates;

  const GetAllRealEstatesSuccess({required this.realEstates});
}

class GetRealEstateCompaniesSuccess extends RealEstateState {
  final List<UserInfo> companies;

  const GetRealEstateCompaniesSuccess({required this.companies});
}

class GetCompanyRealEstatesSuccess extends RealEstateState {
  final List<RealEstate> realEstates;

  const GetCompanyRealEstatesSuccess({required this.realEstates});
}

class AddRealEstateInProgress extends RealEstateState {}

class AddRealEstateFailure extends RealEstateState {
  final String message;

  const AddRealEstateFailure({required this.message});
}

class AddRealEstateSuccess extends RealEstateState {
  final String realEstate;

  const AddRealEstateSuccess({required this.realEstate});
}
