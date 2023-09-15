// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_input_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderInputModel _$OrderInputModelFromJson(Map<String, dynamic> json) =>
    OrderInputModel(
      product: json['product'] as String,
      amount: (json['amount'] as num).toDouble(),
      qty: json['qty'] as int,
    );

Map<String, dynamic> _$OrderInputModelToJson(OrderInputModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'amount': instance.amount,
      'qty': instance.qty,
    };
