part of 'aramex_bloc.dart';

class AramexEvent extends Equatable {
  const AramexEvent();

  @override
  List<Object> get props => [];
}

class CreatePickUpEvent extends AramexEvent {
  final CreatePickUpInputData createPickUpInputData;

  const CreatePickUpEvent({required this.createPickUpInputData});
}

class CreateShipmentEvent extends AramexEvent {
  final CreateShipmentInputData createShipmentInputData;

  const CreateShipmentEvent({required this.createShipmentInputData});
}

class CreatePickUpWithShipmentEvent extends AramexEvent {
  final List<CategoryProducts> products;
  final String line1;
  final String line2;
  final String line3;
  final String city;
  final String stateOrProvinceCode;
  final String countryCode;
  final String department;
  final String personName;
  final String companyName;
  final String phoneNumber1;
  final String cellPhone;
  final String emailAddress;
  final String descriptionOfGoods;

  const CreatePickUpWithShipmentEvent(
      {required this.products,
      required this.line1,
      required this.line2,
      required this.line3,
      required this.city,
      required this.stateOrProvinceCode,
      required this.countryCode,
      required this.department,
      required this.personName,
      required this.companyName,
      required this.phoneNumber1,
      required this.cellPhone,
      required this.emailAddress,
      required this.descriptionOfGoods});
}

class CalculateRateEvent extends AramexEvent {
  final CalculateRateInputData calculateRateInputData;

  const CalculateRateEvent({required this.calculateRateInputData});
}
