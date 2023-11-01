// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrderModel _$MyOrderModelFromJson(Map<String, dynamic> json) => MyOrderModel(
      id: json['_id'] as String,
      userId: UserInfoModel.fromJson(json['userId'] as Map<String, dynamic>),
      clientId:
          UserInfoModel.fromJson(json['clientId'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => OrderProductsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String?,
      shippingAddress: json['shippingAddress'] as String?,
      mobile: json['mobile'] as String?,
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      serviceFee: (json['serviceFee'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$MyOrderModelToJson(MyOrderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'clientId': instance.clientId,
      'products': instance.products,
      'grandTotal': instance.grandTotal,
      'orderStatus': instance.orderStatus,
      'shippingAddress': instance.shippingAddress,
      'mobile': instance.mobile,
      'subTotal': instance.subTotal,
      'serviceFee': instance.serviceFee,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
