part of 'delivery_service_bloc.dart';

abstract class DeliveryServiceEvent extends Equatable {
  const DeliveryServiceEvent();

  @override
  List<Object> get props => [];
}

class GetDeliveryCompanyServicesEvent extends DeliveryServiceEvent {
  final String id;

  const GetDeliveryCompanyServicesEvent({required this.id});
}

class AddDeliveryServiceEvent extends DeliveryServiceEvent {
  final String title;
  final String description;
  final String from;
  final String to;
  final int price;

  const AddDeliveryServiceEvent(
      {required this.title,
      required this.description,
      required this.from,
      required this.to,
      required this.price});
}
