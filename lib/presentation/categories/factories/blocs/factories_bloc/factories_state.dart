part of 'factories_bloc.dart';

abstract class FactoriesState extends Equatable {
  const FactoriesState();

  @override
  List<Object> get props => [];
}

class FactoriesInitial extends FactoriesState {}

class FactoriesInProgress extends FactoriesState {}

class FactoriesSuccess extends FactoriesState {
  final List<Factories> factories;

  const FactoriesSuccess({required this.factories});
}

class FactoryCompaniesSuccess extends FactoriesState {
  final List<UserInfo> companies;

  const FactoryCompaniesSuccess({required this.companies});
}

class FactoriesFailure extends FactoriesState {
  final String message;

  const FactoriesFailure({required this.message});
}
