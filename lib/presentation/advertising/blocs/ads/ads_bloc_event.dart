part of 'ads_bloc_bloc.dart';

abstract class AdsBlocEvent extends Equatable {
  const AdsBlocEvent();

  @override
  List<Object> get props => [];
}

class GetAllAdsEvent extends AdsBlocEvent {}

class GetAdsByType extends AdsBlocEvent {
  final String userAdvertisingType;

  const GetAdsByType({required this.userAdvertisingType});
}

class GetAdsByIdEvent extends AdsBlocEvent {
  final String id;

  const GetAdsByIdEvent({required this.id});
}
