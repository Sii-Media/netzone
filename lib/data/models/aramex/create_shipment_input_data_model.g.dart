// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_shipment_input_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateShipmentInputDataModel _$CreateShipmentInputDataModelFromJson(
        Map<String, dynamic> json) =>
    CreateShipmentInputDataModel(
      shipments: (json['Shipments'] as List<dynamic>)
          .map((e) => ShipmentsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      labelInfo:
          LabelInfoModel.fromJson(json['LabelInfo'] as Map<String, dynamic>),
      clientInfo:
          ClientInfoModel.fromJson(json['ClientInfo'] as Map<String, dynamic>),
      transaction: TransactionsModel.fromJson(
          json['Transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateShipmentInputDataModelToJson(
        CreateShipmentInputDataModel instance) =>
    <String, dynamic>{
      'Shipments': instance.shipments,
      'LabelInfo': instance.labelInfo,
      'ClientInfo': instance.clientInfo,
      'Transaction': instance.transaction,
    };
