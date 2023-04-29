import 'package:equatable/equatable.dart';

class MenFashion extends Equatable {
  final String deviceName;
  final String deviceImg;

  const MenFashion({required this.deviceName, required this.deviceImg});
  @override
  List<Object?> get props => [deviceName, deviceImg];
}
