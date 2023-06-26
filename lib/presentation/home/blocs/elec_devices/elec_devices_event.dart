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

  const GetElcCategoryProductsEvent(
      {required this.department, required this.category});
}

class GetAllProductsEvent extends ElecDevicesEvent {}

class DeleteProductEvent extends ElecDevicesEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});
}

class EditProductEvent extends ElecDevicesEvent {
  final String productId;
  final String name;
  final String description;
  final int price;
  final File? image;
  final File? video;
  final bool? guarantee;
  final String? address;
  final String? madeIn;

  const EditProductEvent(
      {required this.productId,
      required this.name,
      required this.description,
      required this.price,
      required this.image,
      this.video,
      this.guarantee,
      this.address,
      this.madeIn});
}

class GetProductByIdEvent extends ElecDevicesEvent {
  final String productId;

  const GetProductByIdEvent({required this.productId});
}
