import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/shiper_or_consignee_model.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';

class ShipperOrConsignee extends Equatable {
  final String? reference1;
  final String accountNumber;
  final PartyAddress partyAddress;
  final Contact contact;

  const ShipperOrConsignee(
      {required this.reference1,
      required this.accountNumber,
      required this.partyAddress,
      required this.contact});

  @override
  List<Object?> get props => [reference1, accountNumber, partyAddress, contact];
}

extension MapToDomain on ShipperOrConsignee {
  ShipperOrConsigneeModel fromDomain() => ShipperOrConsigneeModel(
        reference1: reference1,
        accountNumber: accountNumber,
        partyAddress: partyAddress.fromDomain(),
        contact: contact.fromDomain(),
      );
}
