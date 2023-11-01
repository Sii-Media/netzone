import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/label_info.dart';
import 'package:netzoon/domain/aramex/entities/shipment.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class CreateShipmentInputData extends Equatable {
  final List<Shipments> shipments;
  final LabelInfo labelInfo;
  final ClientInfo clientInfo;
  final Transaction transaction;

  const CreateShipmentInputData(
      {required this.shipments,
      required this.labelInfo,
      required this.clientInfo,
      required this.transaction});

  @override
  List<Object?> get props => [shipments, labelInfo, clientInfo, transaction];
}
