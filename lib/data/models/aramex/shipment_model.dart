import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/shiper_or_consignee_model.dart';
import 'package:netzoon/data/models/aramex/shipment_details_model.dart';
import 'package:netzoon/domain/aramex/entities/shipment.dart';

part 'shipment_model.g.dart';

@JsonSerializable(createToJson: true)
class ShipmentsModel {
  @JsonKey(name: 'Reference1')
  final String? reference1;

  @JsonKey(name: 'Reference2')
  final String? reference2;

  @JsonKey(name: 'Reference3')
  final String? reference3;

  @JsonKey(name: 'Shipper')
  final ShipperOrConsigneeModel shipper;

  @JsonKey(name: 'Consignee')
  final ShipperOrConsigneeModel consignee;

  @JsonKey(name: 'ThirdParty')
  final String? thirdParty;

  @JsonKey(name: 'ShippingDateTime')
  final String shippingDateTime;

  @JsonKey(name: 'DueDate')
  final String? dueDate;

  @JsonKey(name: 'Comments')
  final String? comments;

  @JsonKey(name: 'Details')
  final ShipmentDetailsModel details;

  @JsonKey(name: 'TransportType')
  final int transportType;

  @JsonKey(name: 'PickupGUID')
  final String? pickupGUID;

  ShipmentsModel({
    required this.reference1,
    required this.reference2,
    required this.reference3,
    required this.shipper,
    required this.consignee,
    required this.thirdParty,
    required this.shippingDateTime,
    required this.dueDate,
    required this.comments,
    required this.details,
    required this.transportType,
    required this.pickupGUID,
  });

  factory ShipmentsModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipmentsModelToJson(this);
}

extension MapToDomain on ShipmentsModel {
  Shipments toDomain() => Shipments(
        reference1: reference1,
        reference2: reference2,
        reference3: reference3,
        shipper: shipper.toDomain(),
        consignee: consignee.toDomain(),
        thirdParty: thirdParty,
        shippingDateTime: shippingDateTime,
        dueDate: dueDate,
        comments: comments,
        details: details.toDomain(),
        transportType: transportType,
        pickupGUID: pickupGUID,
      );
}
