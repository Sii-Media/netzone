import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/total_amount_model.dart';

class TotalAmount extends Equatable {
  final String currencyCode;
  final double value;

  const TotalAmount({required this.currencyCode, required this.value});
  @override
  List<Object?> get props => [currencyCode, value];
}

extension MapToDomain on TotalAmount {
  TotalAmountModel fromDomain() =>
      TotalAmountModel(currencyCode: currencyCode, value: value);
}
