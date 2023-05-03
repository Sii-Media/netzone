import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/deals/entities/deals_info.dart';

class DealsCategory extends Equatable {
  final String categoryName;
  final List<DealsInfo> dealList;

  const DealsCategory({
    required this.categoryName,
    required this.dealList,
  });

  @override
  List<Object?> get props => [categoryName];
}
