import 'package:equatable/equatable.dart';

class ProcessedPickup extends Equatable {
  final String id;
  final String guid;
  final String reference1;

  const ProcessedPickup(
      {required this.id, required this.guid, required this.reference1});

  @override
  List<Object?> get props => [
        id,
        guid,
        reference1,
      ];
}
