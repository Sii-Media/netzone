import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/deals/entities/deals/deals_result.dart';

class DealsResponse extends Equatable {
  final String message;
  final List<DealsResult> dealsCat;

  const DealsResponse({required this.message, required this.dealsCat});

  @override
  List<Object?> get props => [message, dealsCat];
}
