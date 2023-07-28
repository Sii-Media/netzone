part of 'elec_devices_bloc.dart';

abstract class ElecDevicesState extends Equatable {
  const ElecDevicesState();

  @override
  List<Object> get props => [];
}

class ElecDevicesInitial extends ElecDevicesState {}

class ElecDevicesInProgress extends ElecDevicesState {}

class ElecDevicesSuccess extends ElecDevicesState {
  final List<DepartmentsCategories> elecDevices;

  const ElecDevicesSuccess({required this.elecDevices});
}

class ElecDevicesFailure extends ElecDevicesState {
  final String message;

  const ElecDevicesFailure({required this.message});
}

class ElecCategoryProductSuccess extends ElecDevicesState {
  final String? department;
  final String? category;
  final List<CategoryProducts> categoryProducts;

  const ElecCategoryProductSuccess(
      {this.department, this.category, required this.categoryProducts});
}

class DeleteProductInProgress extends ElecDevicesState {}

class DeleteProductSuccess extends ElecDevicesState {}

class DeleteProductFailure extends ElecDevicesState {
  final String message;

  const DeleteProductFailure({required this.message});
}

class EditProductInProgress extends ElecDevicesState {}

class EditProductFailure extends ElecDevicesState {
  final String message;

  const EditProductFailure({required this.message});
}

class EditProductSuccess extends ElecDevicesState {
  final String message;

  const EditProductSuccess({required this.message});
}

class GetProductByIdSuccess extends ElecDevicesState {
  final CategoryProducts product;

  const GetProductByIdSuccess({required this.product});
}

class RateProductInProgress extends ElecDevicesState {}

class RateProductFailure extends ElecDevicesState {
  final String message;

  const RateProductFailure({required this.message});
}

class RateProductSuccess extends ElecDevicesState {
  final String message;

  const RateProductSuccess({required this.message});
}
