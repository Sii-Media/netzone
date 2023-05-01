import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/govermental_details.dart';

class Governmental extends Equatable {
  final String name;
  final List<String> images;
  final GovermentalDetails govermentalDetails;

  const Governmental({
    required this.name,
    required this.images,
    required this.govermentalDetails,
  });
  @override
  List<Object?> get props => [name, images];
}
