import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/party_address.dart';
part 'party_address_model.g.dart';

@JsonSerializable(createToJson: true)
class PartyAddressModel {
  @JsonKey(name: 'Line1')
  final String line1;

  @JsonKey(name: 'Line2')
  final String? line2;

  @JsonKey(name: 'Line3')
  final String? line3;

  @JsonKey(name: 'City')
  final String city;

  @JsonKey(name: 'StateOrProvinceCode')
  final String? stateOrProvinceCode;

  @JsonKey(name: 'PostCode')
  final String? postCode;

  @JsonKey(name: 'CountryCode')
  final String countryCode;

  @JsonKey(name: 'Longitude')
  final int longitude;

  @JsonKey(name: 'Latitude')
  final int latitude;

  PartyAddressModel({
    required this.line1,
    required this.line2,
    required this.line3,
    required this.city,
    required this.stateOrProvinceCode,
    required this.postCode,
    required this.countryCode,
    required this.longitude,
    required this.latitude,
  });

  factory PartyAddressModel.fromJson(Map<String, dynamic> json) =>
      _$PartyAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartyAddressModelToJson(this);
}

extension MapToDomain on PartyAddressModel {
  PartyAddress toDomain() => PartyAddress(
        line1: line1,
        city: city,
        countryCode: countryCode,
        line2: line2,
        line3: line3,
        postCode: postCode,
        stateOrProvinceCode: stateOrProvinceCode,
        longitude: longitude,
        latitude: latitude,
      );
}
