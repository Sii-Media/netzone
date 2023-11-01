import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/notifications_error.dart';
import 'package:netzoon/domain/aramex/entities/processed_pickup.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class CreatePickUpResponse extends Equatable {
  final Transaction transaction;
  final List<NotificationsError> notifications;
  final bool hasError;
  final ProcessedPickup processedPickup;

  const CreatePickUpResponse(
      {required this.transaction,
      required this.notifications,
      required this.hasError,
      required this.processedPickup});

  @override
  List<Object?> get props =>
      [transaction, notifications, hasError, processedPickup];
}
