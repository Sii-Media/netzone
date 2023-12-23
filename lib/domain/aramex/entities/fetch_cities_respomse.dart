import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/notifications_error.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class FetchCitiesResponse extends Equatable {
  final Transaction transaction;
  final List<NotificationsError> notifications;
  final bool hasError;
  final List<String> cities;

  const FetchCitiesResponse(
      {required this.transaction,
      required this.notifications,
      required this.hasError,
      required this.cities});

  @override
  List<Object?> get props => [transaction, notifications, hasError, cities];
}
