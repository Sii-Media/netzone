part of 'customs_bloc.dart';

abstract class CustomsEvent extends Equatable {
  const CustomsEvent();

  @override
  List<Object> get props => [];
}

class GetAllCustomsEvent extends CustomsEvent {}

class GetCustomsCompaniesEvent extends CustomsEvent {
  final String id;

  const GetCustomsCompaniesEvent({required this.id});
}
