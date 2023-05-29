import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone_places_by_id/freezone_company.dart';

class FreezoneResult extends Equatable {
  final String name;
  final String imageUrl;
  final List<FreeZoneCompany> freezoonplaces;

  const FreezoneResult(
      {required this.name,
      required this.imageUrl,
      required this.freezoonplaces});
  @override
  List<Object?> get props => [name, imageUrl, freezoonplaces];
}
