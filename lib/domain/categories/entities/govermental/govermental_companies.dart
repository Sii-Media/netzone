import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental_details.dart';

class GovermentalCompanies extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final List<GovermentalDetails> govermentalCompanies;

  const GovermentalCompanies(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.govermentalCompanies});
  @override
  List<Object?> get props => [id, name, imageUrl, govermentalCompanies];
}
