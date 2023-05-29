import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone.dart';

class FreeZoneResponse extends Equatable {
  final String message;
  final List<FreeZone> results;

  const FreeZoneResponse({required this.message, required this.results});
  @override
  List<Object?> get props => [message, results];
}
