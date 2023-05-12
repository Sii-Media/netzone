import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/tenders/entities/tendersItems/tender_item.dart';

class TenderItemResponse extends Equatable {
  final String message;
  final List<TenderItem> tenderItems;

  const TenderItemResponse({
    required this.message,
    required this.tenderItems,
  });
  @override
  List<Object?> get props => [message, tenderItems];
}
