import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/customs/customs.dart';

part 'customs_model.g.dart';

@JsonSerializable()
class CustomModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String imageUrl;

  CustomModel({required this.id, required this.name, required this.imageUrl});

  factory CustomModel.fromJson(Map<String, dynamic> json) =>
      _$CustomModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomModelToJson(this);
}

extension MapToDomain on CustomModel {
  Customs toDomain() => Customs(id: id, name: name, imageUrl: imageUrl);
}
