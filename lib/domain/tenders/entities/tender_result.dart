import 'package:equatable/equatable.dart';

class TenderResult extends Equatable {
  final String? id;
  final String name;
  final List<String> tendersItems;

  const TenderResult({
    this.id,
    required this.name,
    required this.tendersItems,
  });
  @override
  List<Object?> get props => [id, name, tendersItems];
}
