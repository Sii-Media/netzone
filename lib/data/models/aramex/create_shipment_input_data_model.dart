import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/client_info_model.dart';
import 'package:netzoon/data/models/aramex/label_info_model.dart';
import 'package:netzoon/data/models/aramex/shipment_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';

part 'create_shipment_input_data_model.g.dart';

@JsonSerializable(createToJson: true)
class CreateShipmentInputDataModel {
  @JsonKey(name: 'Shipments')
  final List<ShipmentsModel> shipments;
  @JsonKey(name: 'LabelInfo')
  final LabelInfoModel labelInfo;
  @JsonKey(name: 'ClientInfo')
  final ClientInfoModel clientInfo;
  @JsonKey(name: 'Transaction')
  final TransactionsModel transaction;

  CreateShipmentInputDataModel(
      {required this.shipments,
      required this.labelInfo,
      required this.clientInfo,
      required this.transaction});

  factory CreateShipmentInputDataModel.fromJson(Map<String, dynamic> json) =>
      _$CreateShipmentInputDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateShipmentInputDataModelToJson(this);
}

// extension MapToDomain on CreateShipmentInputDataModel {
//   CreateShipmentInputData toDomain() => CreateShipmentInputData(
//       shipments: shipments.map((e) => e.toDomain()).toList(),
//       labelInfo: labelInfo,
//       clientInfo: clientInfo,
//       transaction: transaction);
// }
