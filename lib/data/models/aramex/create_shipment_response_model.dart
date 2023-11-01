import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/notifications_error_model.dart';
import 'package:netzoon/data/models/aramex/shipment_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';
import 'package:netzoon/domain/aramex/entities/create_shipment_response.dart';

part 'create_shipment_response_model.g.dart';

@JsonSerializable(createToJson: true)
class CreateShipmentResponseModel {
  @JsonKey(name: 'Transaction')
  final TransactionsModel transaction;
  @JsonKey(name: 'Notifications')
  final List<NotificationsErrorModel> notifications;
  @JsonKey(name: 'HasErrors')
  final bool hasError;
  // @JsonKey(name: 'Shipments')
  // final List<ShipmentsModel> shipments;

  CreateShipmentResponseModel({
    required this.transaction,
    required this.notifications,
    required this.hasError,
  });

  factory CreateShipmentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateShipmentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShipmentResponseModelToJson(this);
}

extension MapToDomain on CreateShipmentResponseModel {
  CreateShipmentResponse toDomain() => CreateShipmentResponse(
        transaction: transaction.toDomain(),
        notifications: notifications.map((e) => e.toDomain()).toList(),
        hasError: hasError,
      );
}
