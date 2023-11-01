import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/shipment_model.dart';
import 'package:netzoon/domain/aramex/entities/details.dart';
import 'package:netzoon/domain/aramex/entities/shiper_consignee.dart';

class Shipments extends Equatable {
  final String? reference1;
  final String? reference2;
  final String? reference3;
  final ShipperOrConsignee shipper;
  final ShipperOrConsignee consignee;
  final String? thirdParty;
  final String shippingDateTime;
  final String? dueDate;
  final String? comments;
  final ShipmentDetails details;
  final int transportType;
  final String? pickupGUID;
  const Shipments({
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

  @override
  List<Object?> get props => [
        reference1,
        reference2,
        reference3,
        shipper,
        consignee,
        thirdParty,
        shippingDateTime,
        dueDate,
        comments,
        details,
        transportType,
        pickupGUID,
      ];
}

extension MapToDomain on Shipments {
  ShipmentsModel fromDomain() => ShipmentsModel(
        reference1: reference1,
        reference2: reference2,
        reference3: reference3,
        shipper: shipper.fromDomain(),
        consignee: consignee.fromDomain(),
        thirdParty: thirdParty,
        shippingDateTime: shippingDateTime,
        dueDate: dueDate,
        comments: comments,
        details: details.fromDomain(),
        transportType: transportType,
        pickupGUID: pickupGUID,
      );
}
