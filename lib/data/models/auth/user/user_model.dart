import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/auth/user_info/user_info_model.dart';
import 'package:netzoon/domain/auth/entities/user.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'result')
  final UserInfoModel userInfo;

  UserModel({
    required this.token,
    required this.message,
    required this.userInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

extension MapToDomain on UserModel {
  User toDomain() => User(
        token: token,
        message: message,
        userInfo: userInfo.toDomain(),
      );
}
