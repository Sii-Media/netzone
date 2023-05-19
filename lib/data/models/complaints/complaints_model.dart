import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/complaints/entities/complaints.dart';

part 'complaints_model.g.dart';

@JsonSerializable()
class ComplaintsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String address;
  final String text;
  final String? reply;
  final String? createdAt;

  ComplaintsModel({
    this.id,
    required this.address,
    required this.text,
    this.reply,
    this.createdAt,
  });

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintsModelToJson(this);
}

extension MapToDomain on ComplaintsModel {
  Complaints toDomain() => Complaints(
        address: address,
        text: text,
        reply: reply,
        createdAt: createdAt,
      );
}
