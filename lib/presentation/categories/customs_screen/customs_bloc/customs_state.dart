part of 'customs_bloc.dart';

abstract class CustomsState extends Equatable {
  const CustomsState();

  @override
  List<Object> get props => [];
}

class CustomsInitial extends CustomsState {}

class CustomsInProgress extends CustomsState {}

class CustomsSuccess extends CustomsState {
  final List<Customs> customs;

  const CustomsSuccess({required this.customs});
}

class CustomsCompaniesSuccess extends CustomsState {
  final CustomsCompanies companies;

  const CustomsCompaniesSuccess({required this.companies});
}

class CustomsFailure extends CustomsState {
  final String message;

  const CustomsFailure({required this.message});
}
