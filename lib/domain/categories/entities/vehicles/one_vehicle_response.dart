import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';

class OneVehicleResponse extends Equatable {
  final String message;
  final Vehicle vehicle;

  const OneVehicleResponse({required this.message, required this.vehicle});
  @override
  List<Object?> get props => [message, vehicle];
}
