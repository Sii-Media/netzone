// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_shipment_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShipmentResponseModel _$CreateShipmentResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateShipmentResponseModel(
      transaction: TransactionsModel.fromJson(
          json['Transaction'] as Map<String, dynamic>),
      notifications: (json['Notifications'] as List<dynamic>)
          .map((e) =>
              NotificationsErrorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasError: json['HasErrors'] as bool,
    );

Map<String, dynamic> _$CreateShipmentResponseModelToJson(
        CreateShipmentResponseModel instance) =>
    <String, dynamic>{
      'Transaction': instance.transaction,
      'Notifications': instance.notifications,
      'HasErrors': instance.hasError,
    };
