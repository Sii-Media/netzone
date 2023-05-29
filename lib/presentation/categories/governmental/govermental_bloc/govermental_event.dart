part of 'govermental_bloc.dart';

abstract class GovermentalEvent extends Equatable {
  const GovermentalEvent();

  @override
  List<Object> get props => [];
}

class GetAllGovermentalsEvent extends GovermentalEvent {}

class GetGovermentalCompaniesEvent extends GovermentalEvent {
  final String id;

  const GetGovermentalCompaniesEvent({required this.id});
}
