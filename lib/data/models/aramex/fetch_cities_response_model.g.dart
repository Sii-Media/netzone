// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_cities_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchCitiesResponseModel _$FetchCitiesResponseModelFromJson(
        Map<String, dynamic> json) =>
    FetchCitiesResponseModel(
      transaction: TransactionsModel.fromJson(
          json['Transaction'] as Map<String, dynamic>),
      notifications: (json['Notifications'] as List<dynamic>)
          .map((e) =>
              NotificationsErrorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasError: json['HasErrors'] as bool,
      cities:
          (json['Cities'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FetchCitiesResponseModelToJson(
        FetchCitiesResponseModel instance) =>
    <String, dynamic>{
      'Transaction': instance.transaction,
      'Notifications': instance.notifications,
      'HasErrors': instance.hasError,
      'Cities': instance.cities,
    };
