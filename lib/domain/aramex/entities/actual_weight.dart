import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/actual_weight_model.dart';

class ActualWeight extends Equatable {
  final String unit;
  final double value;

  const ActualWeight({required this.unit, required this.value});

  @override
  List<Object?> get props => [unit, value];
}

extension MapToDomain on ActualWeight {
  ActualWeightModel fromDomain() => ActualWeightModel(unit: unit, value: value);
}
