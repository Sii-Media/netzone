part of 'ads_bloc_bloc.dart';

abstract class AdsBlocEvent extends Equatable {
  const AdsBlocEvent();

  @override
  List<Object> get props => [];
}

class GetAllAdsEvent extends AdsBlocEvent {}
