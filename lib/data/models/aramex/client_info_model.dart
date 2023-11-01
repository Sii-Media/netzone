import 'package:json_annotation/json_annotation.dart';

part 'client_info_model.g.dart';

@JsonSerializable(createToJson: true)
class ClientInfoModel {
  @JsonKey(name: 'Source')
  final int source;
  @JsonKey(name: 'AccountCountryCode')
  final String accountCountryCode;
  @JsonKey(name: 'AccountEntity')
  final String accountEntity;
  @JsonKey(name: 'AccountPin')
  final String accountPin;
  @JsonKey(name: 'AccountNumber')
  final String accountNumber;
  @JsonKey(name: 'UserName')
  final String userName;
  @JsonKey(name: 'Password')
  final String password;
  @JsonKey(name: 'Version')
  final String version;

  ClientInfoModel(
      {required this.source,
      required this.accountCountryCode,
      required this.accountEntity,
      required this.accountPin,
      required this.accountNumber,
      required this.userName,
      required this.password,
      required this.version});

  factory ClientInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ClientInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientInfoModelToJson(this);
}
