import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/rate_shipment_details.dart';

class CalculateRateInputData extends Equatable {
  final PartyAddress originAddress;
  final PartyAddress destinationAddress;
  final RateShipmentDetails shipmentDetails;
  final String preferredCurrencyCode;
  final ClientInfo clientInfo;

  const CalculateRateInputData(
      {required this.originAddress,
      required this.destinationAddress,
      required this.shipmentDetails,
      required this.preferredCurrencyCode,
      required this.clientInfo});
  @override
  List<Object?> get props => [
        originAddress,
        destinationAddress,
        shipmentDetails,
        preferredCurrencyCode,
        clientInfo
      ];
}
