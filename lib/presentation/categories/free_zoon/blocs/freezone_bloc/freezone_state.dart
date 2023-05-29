part of 'freezone_bloc.dart';

abstract class FreezoneState extends Equatable {
  const FreezoneState();

  @override
  List<Object> get props => [];
}

class FreezoneInitial extends FreezoneState {}

class FreezoneInProgress extends FreezoneState {}

class FreezoneSuccess extends FreezoneState {
  final List<FreeZone> freezones;

  const FreezoneSuccess({required this.freezones});
}

class FreezoneByIdSuccess extends FreezoneState {
  final FreezoneResult freezonescompanies;

  const FreezoneByIdSuccess({required this.freezonescompanies});
}

class FreezoneFailure extends FreezoneState {
  final String message;

  const FreezoneFailure({required this.message});
}
