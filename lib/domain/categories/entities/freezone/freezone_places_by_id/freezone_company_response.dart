import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_result.dart';

class FreeZoneCompanyResponse extends Equatable {
  final String message;
  final FreezoneResult results;

  const FreeZoneCompanyResponse({required this.message, required this.results});
  @override
  List<Object?> get props => [message, results];
}
