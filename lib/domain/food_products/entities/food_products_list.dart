import 'package:equatable/equatable.dart';

import '../../electronic_devices/entities/device_list.dart';

class FoodProductList extends Equatable {
  final String name;
  final String imgUrl;
  final List<DeviceList> deviceList;

  const FoodProductList(
      {required this.name, required this.imgUrl, required this.deviceList});
  @override
  List<Object?> get props => [name, imgUrl, deviceList];
}
