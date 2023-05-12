part of 'deals_categoty_bloc.dart';

abstract class DealsCategotyEvent extends Equatable {
  const DealsCategotyEvent();

  @override
  List<Object> get props => [];
}

class GetDealsCategoryEvent extends DealsCategotyEvent {}
