import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/notifications_error.dart';

part 'notifications_error_model.g.dart';

@JsonSerializable(createToJson: true)
class NotificationsErrorModel {
  @JsonKey(name: 'Code')
  final String code;
  @JsonKey(name: 'Message')
  final String message;

  NotificationsErrorModel({required this.code, required this.message});

  factory NotificationsErrorModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsErrorModelToJson(this);
}

extension MapToDomain on NotificationsErrorModel {
  NotificationsError toDomain() => NotificationsError(
        code: code,
        message: message,
      );
}
