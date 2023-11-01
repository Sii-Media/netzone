import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/transactions_model.dart';

class Transaction extends Equatable {
  final String reference1;
  final String? reference2;
  final String? reference3;
  final String? reference4;

  const Transaction(
      {required this.reference1,
      this.reference2,
      this.reference3,
      this.reference4});

  @override
  List<Object?> get props => [reference1, reference2, reference3, reference4];
}

extension MapToDomain on Transaction {
  TransactionsModel fromDomain() => TransactionsModel(
      reference1: reference1,
      reference2: reference2,
      reference3: reference3,
      reference4: reference4);
}
