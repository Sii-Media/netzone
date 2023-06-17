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
