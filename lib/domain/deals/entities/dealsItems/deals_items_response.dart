import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/deals/entities/dealsItems/deals_items.dart';

class DealsItemsResponse extends Equatable {
  final String message;
  final List<DealsItems> dealsItems;

  const DealsItemsResponse({required this.message, required this.dealsItems});
  @override
  List<Object?> get props => [message, dealsItems];
}
