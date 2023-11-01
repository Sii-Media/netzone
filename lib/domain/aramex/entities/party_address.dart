import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/party_address_model.dart';

class PartyAddress extends Equatable {
  final String line1;
  final String? line2;
  final String? line3;
  final String city;
  final String? stateOrProvinceCode;
  final String? postCode;
  final String countryCode;
  final int longitude;
  final int latitude;
  const PartyAddress({
    required this.line1,
    this.line2,
    this.line3,
    required this.city,
    this.stateOrProvinceCode,
    this.postCode,
    required this.countryCode,
    required this.longitude,
    required this.latitude,
  });

  @override
  List<Object?> get props => [
        line1,
        line2,
        line3,
        city,
        stateOrProvinceCode,
        postCode,
        countryCode,
        longitude,
        latitude
      ];
}

extension MapToDomain on PartyAddress {
  PartyAddressModel fromDomain() => PartyAddressModel(
        line1: line1,
        line2: line2,
        line3: line3,
        city: city,
        stateOrProvinceCode: stateOrProvinceCode,
        postCode: postCode,
        countryCode: countryCode,
        longitude: longitude,
        latitude: latitude,
      );
}
