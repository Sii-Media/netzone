import 'package:equatable/equatable.dart';

class DeviceList extends Equatable {
  final String deviceName;
  final String deviceImg;

  const DeviceList({required this.deviceName, required this.deviceImg});
  @override
  List<Object?> get props => [deviceName, deviceImg];
}
