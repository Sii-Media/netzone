import 'package:equatable/equatable.dart';

class TendersCategory extends Equatable {
  final String tendersCategoryName;

  const TendersCategory({required this.tendersCategoryName});
  @override
  List<Object?> get props => [tendersCategoryName];
}
