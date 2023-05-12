import 'package:equatable/equatable.dart';

class DealsResult extends Equatable {
  final String? id;
  final String name;
  final List<String> dealsItems;
  const DealsResult({
    this.id,
    required this.name,
    required this.dealsItems,
  });

  @override
  List<Object?> get props => [
        name,
        dealsItems,
      ];
}
