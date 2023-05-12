part of 'deals_categoty_bloc.dart';

abstract class DealsCategotyState extends Equatable {
  const DealsCategotyState();

  @override
  List<Object> get props => [];
}

class DealsCategotyInitial extends DealsCategotyState {}

class DealsCategotyInProgress extends DealsCategotyState {}

class DealsCategotySuccess extends DealsCategotyState {
  final List<DealsResult> dealsCat;

  const DealsCategotySuccess({required this.dealsCat});
}

class DealsCategotyFailure extends DealsCategotyState {
  final String message;

  const DealsCategotyFailure({required this.message});
}
