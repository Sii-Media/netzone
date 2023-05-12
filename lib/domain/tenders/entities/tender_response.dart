import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/tenders/entities/tender_result.dart';

class TenderResponse extends Equatable {
  final String message;
  final List<TenderResult> tendersCat;

  const TenderResponse({required this.message, required this.tendersCat});
  @override
  List<Object?> get props => [message, tendersCat];
}
