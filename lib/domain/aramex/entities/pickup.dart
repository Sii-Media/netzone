import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/pickup_model.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
import 'package:netzoon/domain/aramex/entities/pickup_items.dart';

class PickUp extends Equatable {
  final PartyAddress pickupAddress;
  final Contact pickupContact;
  final String pickupLocation;
  final String pickupDate;
  final String readyTime;
  final String lastPickupTime;
  final String closingTime;
  final String comments;
  final String reference1;
  final String vehicle;
  final List<PickupItems> pickupItems;
  final String status;
  final String branch;
  final String routeCode;
  const PickUp({
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

  @override
  List<Object?> get props => [
        pickupAddress,
        pickupContact,
        pickupLocation,
        pickupDate,
        readyTime,
        lastPickupTime,
        closingTime,
        comments,
        reference1,
        vehicle,
        pickupItems,
        status,
        branch,
        routeCode,
      ];
}

extension MapToDomain on PickUp {
  PickUpModel fromDomain() => PickUpModel(
        pickupAddress: pickupAddress.fromDomain(),
        pickupContact: pickupContact.fromDomain(),
        pickupLocation: pickupLocation,
        pickupDate: pickupDate,
        readyTime: readyTime,
        lastPickupTime: lastPickupTime,
        closingTime: closingTime,
        comments: comments,
        reference1: reference1,
        vehicle: vehicle,
        pickupItems: pickupItems.map((e) => e.fromDomain()).toList(),
        status: status,
        branch: branch,
        routeCode: routeCode,
      );
}
