part of 'aramex_bloc.dart';

class AramexState extends Equatable {
  const AramexState();

  @override
  List<Object> get props => [];
}

class AramexInitial extends AramexState {}

class CreatePickUpInProgress extends AramexState {}

class CreatePickUpInFailue extends AramexState {
  final String message;

  const CreatePickUpInFailue({required this.message});
}

class CreatePickUpSuccess extends AramexState {
  final CreatePickUpResponse createPickUpResponse;

  const CreatePickUpSuccess({required this.createPickUpResponse});
}

class CreateShipmentInProgress extends AramexState {}

class CreateShipmentInFailue extends AramexState {
  final String message;

  const CreateShipmentInFailue({required this.message});
}

class CreateShipmentSuccess extends AramexState {
  final CreateShipmentResponse createShipmentResponse;

  const CreateShipmentSuccess({required this.createShipmentResponse});
}

class CreatePickUpWithShipmentInProgress extends AramexState {}

class CreatePickUpWithShipmentFailuer extends AramexState {
  final String message;

  const CreatePickUpWithShipmentFailuer({required this.message});
}

class CreatePickUpWithShipmentSuccess extends AramexState {
  final CreateShipmentResponse createShipmentResponse;

  const CreatePickUpWithShipmentSuccess({required this.createShipmentResponse});
}

class CalculateRateInProgress extends AramexState {}

class CalculateRateFailure extends AramexState {
  final String message;

  const CalculateRateFailure({required this.message});
}

class CalculateRateSuccess extends AramexState {
  final CalculateRateResponse calculateRateResponse;

  const CalculateRateSuccess({required this.calculateRateResponse});
}
