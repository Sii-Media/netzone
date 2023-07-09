part of 'real_estate_bloc.dart';

abstract class RealEstateEvent extends Equatable {
  const RealEstateEvent();

  @override
  List<Object> get props => [];
}

class GetAllRealEstatesEvent extends RealEstateEvent {}
