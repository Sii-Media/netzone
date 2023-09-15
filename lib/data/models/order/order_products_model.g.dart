// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductsModel _$OrderProductsModelFromJson(Map<String, dynamic> json) =>
    OrderProductsModel(
      id: json['_id'] as String,
      product: CategoryProductsModel.fromJson(
          json['product'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toDouble(),
      qty: json['qty'] as int,
    );

Map<String, dynamic> _$OrderProductsModelToJson(OrderProductsModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product': instance.product,
      'amount': instance.amount,
      'qty': instance.qty,
    };
