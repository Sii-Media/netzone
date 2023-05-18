import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/requests/entities/request.dart';

part 'requests_model.g.dart';

@JsonSerializable()
class RequestsModel {
  @JsonKey(name: '_id')
  final String? id;
  final String address;
  final String text;

  RequestsModel({this.id, required this.address, required this.text});
  factory RequestsModel.fromJson(Map<String, dynamic> json) =>
      _$RequestsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestsModelToJson(this);
}

extension MapToDomain on RequestsModel {
  Requests toDomain() => Requests(
        address: address,
        text: text,
      );
}
