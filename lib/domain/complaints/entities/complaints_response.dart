import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/complaints/entities/complaints.dart';

class ComplaintsResponse extends Equatable {
  final String message;
  final List<Complaints> complaints;

  const ComplaintsResponse({required this.message, required this.complaints});
  @override
  List<Object?> get props => [message, complaints];
}
