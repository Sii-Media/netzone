part of 'elec_devices_bloc.dart';

abstract class ElecDevicesEvent extends Equatable {
  const ElecDevicesEvent();

  @override
  List<Object> get props => [];
}

class GetElcDevicesEvent extends ElecDevicesEvent {
  final String department;

  const GetElcDevicesEvent({required this.department});
}

class GetElcCategoryProductsEvent extends ElecDevicesEvent {
  final String department;
  final String category;
  final double? priceMin;
  final double? priceMax;
  final String? owner;
  final String? condition;
  const GetElcCategoryProductsEvent({
    required this.department,
    required this.category,
    this.priceMin,
    this.priceMax,
    this.owner,
    this.condition,
  });
}

class GetAllProductsEvent extends ElecDevicesEvent {}

class GetSelectableProductsEvent extends ElecDevicesEvent {}

class DeleteProductEvent extends ElecDevicesEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});
}

class EditProductEvent extends ElecDevicesEvent {
  final String productId;
  final String name;
  final String description;
  final double price;
  final int? quantity;
  final double? weight;
  final File? image;
  final File? video;
  final bool? guarantee;
  final String? address;
  final String? madeIn;
  final String? color;
  final int? discountPercentage;

  const EditProductEvent({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    this.quantity,
    this.weight,
    required this.image,
    this.video,
    this.guarantee,
    this.address,
    this.madeIn,
    this.color,
    this.discountPercentage,
  });
}

class GetProductByIdEvent extends ElecDevicesEvent {
  final String productId;

  const GetProductByIdEvent({required this.productId});
}

class SearchProductsEvent extends ElecDevicesEvent {
  final String searchQuery;

  const SearchProductsEvent({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}

class RateProductEvent extends ElecDevicesEvent {
  final String id;
  final double rating;

  const RateProductEvent({required this.id, required this.rating});
}
