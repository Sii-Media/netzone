import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/aramex/entities/client_info.dart';
import 'package:netzoon/domain/aramex/entities/label_info.dart';
import 'package:netzoon/domain/aramex/entities/pickup.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';

class CreatePickUpInputData extends Equatable {
  final ClientInfo clientInfo;
  final LabelInfo labelInfo;
  final PickUp pickUp;
  final Transaction transaction;

  const CreatePickUpInputData(
      {required this.clientInfo,
      required this.labelInfo,
      required this.pickUp,
      required this.transaction});

  @override
  List<Object?> get props => [clientInfo, labelInfo, pickUp, transaction];
}
