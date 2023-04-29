import 'package:equatable/equatable.dart';

class DealsCategory extends Equatable {
  final String dealsCategoryName;

  const DealsCategory({required this.dealsCategoryName});

  @override
  List<Object?> get props => [dealsCategoryName];
}
