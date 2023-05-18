import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/requests/entities/request.dart';

class RequestResponse extends Equatable {
  final String message;
  final Requests requests;

  const RequestResponse({required this.message, required this.requests});
  @override
  List<Object?> get props => [message, requests];
}
