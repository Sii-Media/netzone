import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/govermental/govermental.dart';

part 'govermental_model.g.dart';

@JsonSerializable()
class GovermentalModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imageUrl;

  GovermentalModel(
      {required this.id, required this.name, required this.imageUrl});

  factory GovermentalModel.fromJson(Map<String, dynamic> json) =>
      _$GovermentalModelFromJson(json);

  Map<String, dynamic> toJson() => _$GovermentalModelToJson(this);
}

extension MapToDomain on GovermentalModel {
  Govermental toDomain() => Govermental(
        id: id,
        name: name,
        imageUrl: imageUrl,
      );
}
