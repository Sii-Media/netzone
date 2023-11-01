import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/notifications_error_model.dart';
import 'package:netzoon/data/models/aramex/total_amount_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';
import 'package:netzoon/domain/aramex/entities/calculate_rate_response.dart';

part 'calculate_rate_response_model.g.dart';

@JsonSerializable(createToJson: true)
class CalculateRateResponseModel {
  @JsonKey(name: 'Transaction')
  final TransactionsModel? transaction;
  @JsonKey(name: 'Notifications')
  final List<NotificationsErrorModel> notifications;
  @JsonKey(name: 'HasErrors')
  final bool hasErrors;
  @JsonKey(name: 'TotalAmount')
  final TotalAmountModel totalAmount;

  CalculateRateResponseModel(
      {required this.transaction,
      required this.notifications,
      required this.hasErrors,
      required this.totalAmount});

  factory CalculateRateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CalculateRateResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateRateResponseModelToJson(this);
}

extension MapToDomain on CalculateRateResponseModel {
  CalculateRateResponse toDomain() => CalculateRateResponse(
      transaction: transaction == null ? null : transaction!.toDomain(),
      notifications: notifications.map((e) => e.toDomain()).toList(),
      hasError: hasErrors,
      totalAmount: totalAmount.toDomain());
}
