import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/notifications_error_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';
import 'package:netzoon/domain/aramex/entities/fetch_cities_respomse.dart';

part 'fetch_cities_response_model.g.dart';

@JsonSerializable(createToJson: true)
class FetchCitiesResponseModel {
  @JsonKey(name: 'Transaction')
  final TransactionsModel transaction;
  @JsonKey(name: 'Notifications')
  final List<NotificationsErrorModel> notifications;
  @JsonKey(name: 'HasErrors')
  final bool hasError;
  @JsonKey(name: 'Cities')
  final List<String> cities;

  factory FetchCitiesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FetchCitiesResponseModelFromJson(json);

  FetchCitiesResponseModel(
      {required this.transaction,
      required this.notifications,
      required this.hasError,
      required this.cities});
}

extension MapToDomain on FetchCitiesResponseModel {
  FetchCitiesResponse toDomain() => FetchCitiesResponse(
      transaction: transaction.toDomain(),
      notifications: notifications.map((e) => e.toDomain()).toList(),
      hasError: hasError,
      cities: cities);
}
