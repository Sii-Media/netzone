import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/notifications_error.dart';
import 'package:netzoon/domain/aramex/entities/total_amount.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class CalculateRateResponse extends Equatable {
  final Transaction? transaction;
  final List<NotificationsError> notifications;
  final bool hasError;
  final TotalAmount totalAmount;

  const CalculateRateResponse(
      {required this.transaction,
      required this.notifications,
      required this.hasError,
      required this.totalAmount});
  @override
  List<Object?> get props =>
      [transaction, notifications, hasError, totalAmount];
}
