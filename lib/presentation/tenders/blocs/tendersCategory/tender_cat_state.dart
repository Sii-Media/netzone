part of 'tender_cat_bloc.dart';

abstract class TenderCatState extends Equatable {
  const TenderCatState();

  @override
  List<Object> get props => [];
}

class TenderCatInitial extends TenderCatState {}

class TenderCatInProgress extends TenderCatState {}

class TenderCatSuccess extends TenderCatState {
  final List<TenderResult> tenderCat;

  const TenderCatSuccess({required this.tenderCat});
}

class TenderCatFailure extends TenderCatState {
  final String message;

  const TenderCatFailure({required this.message});
}
