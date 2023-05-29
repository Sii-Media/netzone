part of 'freezone_bloc.dart';

abstract class FreezoneEvent extends Equatable {
  const FreezoneEvent();

  @override
  List<Object> get props => [];
}

class GetFreeZonePlacesEvent extends FreezoneEvent {}

class GetFreeZonePlacesByIdEvent extends FreezoneEvent {
  final String id;

  const GetFreeZonePlacesByIdEvent({required this.id});
}
