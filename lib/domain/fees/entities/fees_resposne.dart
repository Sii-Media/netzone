import 'package:equatable/equatable.dart';

class FeesResponse extends Equatable {
  final double? feesFromSeller;
  final double? feesFromBuyer;
  final double? adsFees;
  final double? dealsFees;

  const FeesResponse(
      {required this.feesFromSeller,
      required this.feesFromBuyer,
      required this.adsFees,
      required this.dealsFees});
  @override
  List<Object?> get props =>
      [feesFromBuyer, feesFromSeller, adsFees, dealsFees];
}
