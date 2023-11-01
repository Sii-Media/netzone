// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_rate_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateRateResponseModel _$CalculateRateResponseModelFromJson(
        Map<String, dynamic> json) =>
    CalculateRateResponseModel(
      transaction: json['Transaction'] == null
          ? null
          : TransactionsModel.fromJson(
              json['Transaction'] as Map<String, dynamic>),
      notifications: (json['Notifications'] as List<dynamic>)
          .map((e) =>
              NotificationsErrorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasErrors: json['HasErrors'] as bool,
      totalAmount: TotalAmountModel.fromJson(
          json['TotalAmount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CalculateRateResponseModelToJson(
        CalculateRateResponseModel instance) =>
    <String, dynamic>{
      'Transaction': instance.transaction,
      'Notifications': instance.notifications,
      'HasErrors': instance.hasErrors,
      'TotalAmount': instance.totalAmount,
    };
