import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/freezone/freezone.dart';

part 'freezone_model.g.dart';

@JsonSerializable()
class FreeZoneModel {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String imageUrl;

  FreeZoneModel({this.id, required this.name, required this.imageUrl});

  factory FreeZoneModel.fromJson(Map<String, dynamic> json) =>
      _$FreeZoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$FreeZoneModelToJson(this);
}

extension MapToDomain on FreeZoneModel {
  FreeZone toDomain() => FreeZone(
        name: name,
        imageUrl: imageUrl,
      );
}
