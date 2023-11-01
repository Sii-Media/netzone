import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/transaction.dart';
part 'transactions_model.g.dart';

@JsonSerializable(createToJson: true)
class TransactionsModel {
  @JsonKey(name: 'Reference1')
  final String reference1;
  @JsonKey(name: 'Reference2')
  final String? reference2;
  @JsonKey(name: 'Reference3')
  final String? reference3;
  @JsonKey(name: 'Reference4')
  final String? reference4;

  TransactionsModel(
      {required this.reference1,
      required this.reference2,
      required this.reference3,
      required this.reference4});

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsModelToJson(this);
}

extension MapToDomain on TransactionsModel {
  Transaction toDomain() => Transaction(
        reference1: reference1,
        reference2: reference2,
        reference3: reference3,
        reference4: reference4,
      );
}
