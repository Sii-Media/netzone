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
