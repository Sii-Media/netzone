part of 'govermental_bloc.dart';

abstract class GovermentalState extends Equatable {
  const GovermentalState();

  @override
  List<Object> get props => [];
}

class GovermentalInitial extends GovermentalState {}

class GovermentalInProgress extends GovermentalState {}

class GovermentalSuccess extends GovermentalState {
  final List<Govermental> govermentals;

  const GovermentalSuccess({required this.govermentals});
}

class GovermentalCompaniesSuccess extends GovermentalState {
  final GovermentalCompanies companies;

  const GovermentalCompaniesSuccess({required this.companies});
}

class GovermentalFailure extends GovermentalState {
  final String message;

  const GovermentalFailure({required this.message});
}
