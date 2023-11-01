// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_pickup_input_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePickUpInputDataModel _$CreatePickUpInputDataModelFromJson(
        Map<String, dynamic> json) =>
    CreatePickUpInputDataModel(
      clientInfo:
          ClientInfoModel.fromJson(json['ClientInfo'] as Map<String, dynamic>),
      labelInfo:
          LabelInfoModel.fromJson(json['LabelInfo'] as Map<String, dynamic>),
      pickUp: PickUpModel.fromJson(json['PickUp'] as Map<String, dynamic>),
      transaction: TransactionsModel.fromJson(
          json['Transaction'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePickUpInputDataModelToJson(
        CreatePickUpInputDataModel instance) =>
    <String, dynamic>{
      'ClientInfo': instance.clientInfo,
      'LabelInfo': instance.labelInfo,
      'PickUp': instance.pickUp,
      'Transaction': instance.transaction,
    };
