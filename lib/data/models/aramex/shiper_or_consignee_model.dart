import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/contact_model.dart';
import 'package:netzoon/data/models/aramex/party_address_model.dart';
import 'package:netzoon/domain/aramex/entities/shiper_consignee.dart';

part 'shiper_or_consignee_model.g.dart';

@JsonSerializable(createToJson: true)
class ShipperOrConsigneeModel {
  @JsonKey(name: 'Reference1')
  final String? reference1;

  @JsonKey(name: 'AccountNumber')
  final String accountNumber;

  @JsonKey(name: 'PartyAddress')
  final PartyAddressModel partyAddress;

  @JsonKey(name: 'Contact')
  final ContactModel contact;

  ShipperOrConsigneeModel(
      {required this.reference1,
      required this.accountNumber,
      required this.partyAddress,
      required this.contact});

  factory ShipperOrConsigneeModel.fromJson(Map<String, dynamic> json) =>
      _$ShipperOrConsigneeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShipperOrConsigneeModelToJson(this);
}

extension MapToDomain on ShipperOrConsigneeModel {
  ShipperOrConsignee toDomain() => ShipperOrConsignee(
      reference1: reference1,
      accountNumber: accountNumber,
      partyAddress: partyAddress.toDomain(),
      contact: contact.toDomain());
}
