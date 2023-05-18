import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/openions/entities/openion.dart';

part 'openion_model.g.dart';

@JsonSerializable()
class OpenionModel {
  @JsonKey(name: '_id')
  final String? id;
  final String text;

  OpenionModel({this.id, required this.text});

  factory OpenionModel.fromJson(Map<String, dynamic> json) =>
      _$OpenionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenionModelToJson(this);
}

extension MapToDomain on OpenionModel {
  Openion toDomain() => Openion(
        text: text,
      );
}
