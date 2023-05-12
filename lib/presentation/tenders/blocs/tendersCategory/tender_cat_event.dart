part of 'tender_cat_bloc.dart';

abstract class TenderCatEvent extends Equatable {
  const TenderCatEvent();

  @override
  List<Object> get props => [];
}

class GetAllTendersCatEvent extends TenderCatEvent {}
