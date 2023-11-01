import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/notifications_error.dart';
import 'package:netzoon/domain/aramex/entities/shipment.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class CreateShipmentResponse extends Equatable {
  final Transaction transaction;
  final List<NotificationsError> notifications;
  final bool hasError;
  // final List<Shipments> shipments;

  const CreateShipmentResponse({
    required this.transaction,
    required this.notifications,
    required this.hasError,
  });

  @override
  List<Object?> get props => [
        transaction,
        notifications,
        hasError,
      ];
}
