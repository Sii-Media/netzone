import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/electronic_devices/entities/device_list.dart';

class ElectronicDevice extends Equatable {
  final String name;
  final String imgUrl;
  final List<DeviceList> deviceList;

  const ElectronicDevice({
    required this.name,
    required this.imgUrl,
    required this.deviceList,
  });
  @override
  List<Object?> get props => [name, imgUrl];
}
