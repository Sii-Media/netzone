import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/vehicles/vehicle.dart';

class VehicleResponse extends Equatable {
  final String message;
  final List<Vehicle> vehicle;

  const VehicleResponse({required this.message, required this.vehicle});
  @override
  List<Object?> get props => [message, vehicle];
}
