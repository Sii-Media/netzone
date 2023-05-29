import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/categories/entities/factories/factories.dart';

part 'factories_model.g.dart';

@JsonSerializable()
class FactoriesModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;

  FactoriesModel({required this.id, required this.title});

  factory FactoriesModel.fromJson(Map<String, dynamic> json) =>
      _$FactoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactoriesModelToJson(this);
}

extension MapToDomain on FactoriesModel {
  Factories toDomain() => Factories(id: id, title: title);
}
