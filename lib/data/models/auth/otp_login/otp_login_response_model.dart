import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/auth/entities/otp_login_response.dart';

part 'otp_login_response_model.g.dart';

@JsonSerializable()
class OtpLoginResponseModel {
  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final String data;

  OtpLoginResponseModel({required this.message, required this.data});

  factory OtpLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpLoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpLoginResponseModelToJson(this);
}

extension MapToDomain on OtpLoginResponseModel {
  OtpLoginResponse toDomain() => OtpLoginResponse(message: message, data: data);
}
