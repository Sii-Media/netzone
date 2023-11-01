import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/client_info_model.dart';
import 'package:netzoon/data/models/aramex/party_address_model.dart';
import 'package:netzoon/data/models/aramex/rate_shipment_details_model.dart';

part 'calculate_rate_input_data_model.g.dart';

@JsonSerializable(createToJson: true)
class CalculateRateInputDataModel {
  @JsonKey(name: 'OriginAddress')
  final PartyAddressModel originAddress;
  @JsonKey(name: 'DestinationAddress')
  final PartyAddressModel destinationAddress;
  @JsonKey(name: 'ShipmentDetails')
  final RateShipmentDetailsModel shipmentDetails;
  @JsonKey(name: 'PreferredCurrencyCode')
  final String preferredCurrencyCode;
  @JsonKey(name: 'ClientInfo')
  final ClientInfoModel clientInfo;

  CalculateRateInputDataModel(
      {required this.originAddress,
      required this.destinationAddress,
      required this.shipmentDetails,
      required this.preferredCurrencyCode,
      required this.clientInfo});

  factory CalculateRateInputDataModel.fromJson(Map<String, dynamic> json) =>
      _$CalculateRateInputDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateRateInputDataModelToJson(this);
}
