import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/aramex/client_info_model.dart';
import 'package:netzoon/data/models/aramex/label_info_model.dart';
import 'package:netzoon/data/models/aramex/pickup_model.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';

part 'create_pickup_input_data_model.g.dart';

@JsonSerializable(createToJson: true)
class CreatePickUpInputDataModel {
  @JsonKey(name: 'ClientInfo')
  final ClientInfoModel clientInfo;
  @JsonKey(name: 'LabelInfo')
  final LabelInfoModel labelInfo;
  @JsonKey(name: 'PickUp')
  final PickUpModel pickUp;
  @JsonKey(name: 'Transaction')
  final TransactionsModel transaction;

  CreatePickUpInputDataModel(
      {required this.clientInfo,
      required this.labelInfo,
      required this.pickUp,
      required this.transaction});

  factory CreatePickUpInputDataModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePickUpInputDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePickUpInputDataModelToJson(this);
}
