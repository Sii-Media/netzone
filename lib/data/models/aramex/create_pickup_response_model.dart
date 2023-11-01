import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/notifications_error_model.dart';
import 'package:netzoon/data/models/aramex/processed_pickup_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';
import 'package:netzoon/domain/aramex/entities/create_pickup_response.dart';

part 'create_pickup_response_model.g.dart';

@JsonSerializable(createToJson: true)
class CreatePickUpResponseModel {
  @JsonKey(name: 'Transaction')
  final TransactionsModel transaction;
  @JsonKey(name: 'Notifications')
  final List<NotificationsErrorModel> notifications;
  @JsonKey(name: 'HasErrors')
  final bool hasError;
  @JsonKey(name: 'ProcessedPickup')
  final ProcessedPickupModel processedPickup;

  factory CreatePickUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePickUpResponseModelFromJson(json);

  CreatePickUpResponseModel(
      {required this.transaction,
      required this.notifications,
      required this.hasError,
      required this.processedPickup});

  Map<String, dynamic> toJson() => _$CreatePickUpResponseModelToJson(this);
}

extension MapToDomain on CreatePickUpResponseModel {
  CreatePickUpResponse toDomain() => CreatePickUpResponse(
      transaction: transaction.toDomain(),
      notifications: notifications.map((e) => e.toDomain()).toList(),
      hasError: hasError,
      processedPickup: processedPickup.toDomain());
}
