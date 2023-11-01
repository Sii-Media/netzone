// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_pickup_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePickUpResponseModel _$CreatePickUpResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreatePickUpResponseModel(
      transaction: TransactionsModel.fromJson(
          json['Transaction'] as Map<String, dynamic>),
      notifications: (json['Notifications'] as List<dynamic>)
          .map((e) =>
              NotificationsErrorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasError: json['HasErrors'] as bool,
      processedPickup: ProcessedPickupModel.fromJson(
          json['ProcessedPickup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePickUpResponseModelToJson(
        CreatePickUpResponseModel instance) =>
    <String, dynamic>{
      'Transaction': instance.transaction,
      'Notifications': instance.notifications,
      'HasErrors': instance.hasError,
      'ProcessedPickup': instance.processedPickup,
    };
