import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/requests/requests_model.dart';
import 'package:netzoon/domain/requests/entities/request_response.dart';

part 'requests_response_model.g.dart';

@JsonSerializable()
class RequestsResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final RequestsModel requestsModel;

  RequestsResponseModel({required this.message, required this.requestsModel});

  factory RequestsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RequestsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestsResponseModelToJson(this);
}

extension MapToDomain on RequestsResponseModel {
  RequestResponse toDomain() => RequestResponse(
        message: message,
        requests: requestsModel.toDomain(),
      );
}
