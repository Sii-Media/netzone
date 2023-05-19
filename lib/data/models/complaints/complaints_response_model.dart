import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/complaints/complaints_model.dart';
import 'package:netzoon/domain/complaints/entities/complaints_response.dart';

part 'complaints_response_model.g.dart';

@JsonSerializable()
class ComplaintsResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final List<ComplaintsModel> complaintsModel;

  ComplaintsResponseModel({
    required this.message,
    required this.complaintsModel,
  });

  factory ComplaintsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ComplaintsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintsResponseModelToJson(this);
}

extension MapToDomain on ComplaintsResponseModel {
  ComplaintsResponse toDomain() => ComplaintsResponse(
        message: message,
        complaints: complaintsModel.map((e) => e.toDomain()).toList(),
      );
}
