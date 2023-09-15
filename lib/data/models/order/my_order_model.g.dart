// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrderModel _$MyOrderModelFromJson(Map<String, dynamic> json) => MyOrderModel(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => OrderProductsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$MyOrderModelToJson(MyOrderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'products': instance.products,
      'grandTotal': instance.grandTotal,
      'orderStatus': instance.orderStatus,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
