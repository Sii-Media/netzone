import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/contact_model.dart';
import 'package:netzoon/data/models/aramex/party_address_model.dart';
import 'package:netzoon/data/models/aramex/pickup_items_model.dart';
import 'package:netzoon/domain/aramex/entities/pickup.dart';

part 'pickup_model.g.dart';

@JsonSerializable(createToJson: true)
class PickUpModel {
  @JsonKey(name: 'PickupAddress')
  final PartyAddressModel pickupAddress;

  @JsonKey(name: 'PickupContact')
  final ContactModel pickupContact;

  @JsonKey(name: 'PickupLocation')
  final String pickupLocation;

  @JsonKey(name: 'PickupDate')
  final String pickupDate;

  @JsonKey(name: 'ReadyTime')
  final String readyTime;

  @JsonKey(name: 'LastPickupTime')
  final String lastPickupTime;

  @JsonKey(name: 'ClosingTime')
  final String closingTime;

  @JsonKey(name: 'Comments')
  final String comments;

  @JsonKey(name: 'Reference1')
  final String reference1;

  @JsonKey(name: 'Vehicle')
  final String vehicle;

  @JsonKey(name: 'PickupItems')
  final List<PickUpItemsModel> pickupItems;

  @JsonKey(name: 'Status')
  final String status;

  @JsonKey(name: 'Branch')
  final String branch;

  @JsonKey(name: 'RouteCode')
  final String routeCode;

  PickUpModel({
    required this.pickupAddress,
    required this.pickupContact,
    required this.pickupLocation,
    required this.pickupDate,
    required this.readyTime,
    required this.lastPickupTime,
    required this.closingTime,
    required this.comments,
    required this.reference1,
    required this.vehicle,
    required this.pickupItems,
    required this.status,
    required this.branch,
    required this.routeCode,
  });
  factory PickUpModel.fromJson(Map<String, dynamic> json) =>
      _$PickUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$PickUpModelToJson(this);
}

extension MapToDomain on PickUpModel {
  PickUp toDomain() => PickUp(
        pickupAddress: pickupAddress.toDomain(),
        pickupContact: pickupContact.toDomain(),
        pickupLocation: pickupLocation,
        pickupDate: pickupDate,
        readyTime: readyTime,
        lastPickupTime: lastPickupTime,
        closingTime: closingTime,
        comments: comments,
        reference1: reference1,
        vehicle: vehicle,
        pickupItems: pickupItems.map((e) => e.toDomain()).toList(),
        status: status,
        branch: branch,
        routeCode: routeCode,
      );
}
