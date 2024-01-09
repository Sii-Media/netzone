part of 'delivery_service_bloc.dart';

abstract class DeliveryServiceState extends Equatable {
  const DeliveryServiceState();

  @override
  List<Object> get props => [];
}

class DeliveryServiceInitial extends DeliveryServiceState {}

class DeliveryServiceInProgress extends DeliveryServiceState {}

class DeliveryServiceFailure extends DeliveryServiceState {
  final String message;
  final Failure failure;
  const DeliveryServiceFailure({
    required this.message,
    required this.failure,
  });
}

class GetDeliveryCompanyServicesSuccess extends DeliveryServiceState {
  final List<DeliveryService> services;

  const GetDeliveryCompanyServicesSuccess({required this.services});
}

class AddDeliverServiceSuccess extends DeliveryServiceState {
  final String message;

  const AddDeliverServiceSuccess({required this.message});
}
