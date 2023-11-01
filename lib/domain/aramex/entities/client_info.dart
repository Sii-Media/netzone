import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/client_info_model.dart';

class ClientInfo extends Equatable {
  final int source;
  final String accountCountryCode;
  final String accountEntity;
  final String accountPin;
  final String accountNumber;
  final String userName;
  final String password;
  final String version;

  const ClientInfo(
      {required this.source,
      required this.accountCountryCode,
      required this.accountEntity,
      required this.accountPin,
      required this.accountNumber,
      required this.userName,
      required this.password,
      required this.version});

  @override
  List<Object?> get props => [
        source,
        accountCountryCode,
        accountEntity,
        accountPin,
        accountNumber,
        userName,
        password,
        version
      ];
}

extension MapToDomain on ClientInfo {
  ClientInfoModel fromDomain() => ClientInfoModel(
      source: source,
      accountCountryCode: accountCountryCode,
      accountEntity: accountEntity,
      accountPin: accountPin,
      accountNumber: accountNumber,
      userName: userName,
      password: password,
      version: version);
}
