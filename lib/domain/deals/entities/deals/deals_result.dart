import 'package:equatable/equatable.dart';

class DealsResult extends Equatable {
  final String? id;
  final String name;
  final String? nameAr;
  final List<String> dealsItems;
  const DealsResult({
    this.id,
    required this.name,
    this.nameAr,
    required this.dealsItems,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        dealsItems,
      ];
}
