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
