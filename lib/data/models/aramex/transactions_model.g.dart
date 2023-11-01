// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionsModel _$TransactionsModelFromJson(Map<String, dynamic> json) =>
    TransactionsModel(
      reference1: json['Reference1'] as String,
      reference2: json['Reference2'] as String?,
      reference3: json['Reference3'] as String?,
      reference4: json['Reference4'] as String?,
    );

Map<String, dynamic> _$TransactionsModelToJson(TransactionsModel instance) =>
    <String, dynamic>{
      'Reference1': instance.reference1,
      'Reference2': instance.reference2,
      'Reference3': instance.reference3,
      'Reference4': instance.reference4,
    };
