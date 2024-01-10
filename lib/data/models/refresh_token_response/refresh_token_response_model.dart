import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_model.g.dart';

@JsonSerializable()
class RefreshTokenResponseModel {
  @JsonKey(name: 'refreshToken')
  final String refreshToken;

  RefreshTokenResponseModel({required this.refreshToken});
  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseModelFromJson(json);
}
