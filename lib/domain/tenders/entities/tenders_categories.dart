import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/tenders/entities/tender.dart';

class TendersCategory extends Equatable {
  final String tendersCategoryName;
  final List<Tender> tenderList;

  const TendersCategory({
    required this.tendersCategoryName,
    required this.tenderList,
  });
  @override
  List<Object?> get props => [tendersCategoryName];
}
