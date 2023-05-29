part of 'factories_bloc.dart';

abstract class FactoriesEvent extends Equatable {
  const FactoriesEvent();

  @override
  List<Object> get props => [];
}

class GetAllFactoriesEvent extends FactoriesEvent {}

class GetFactoryCompaniesEvent extends FactoriesEvent {
  final String id;

  const GetFactoryCompaniesEvent({required this.id});
}
