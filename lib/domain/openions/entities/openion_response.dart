import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/openions/entities/openion.dart';

class OpenionResponse extends Equatable {
  final String message;
  final Openion openions;

  const OpenionResponse({required this.message, required this.openions});
  @override
  List<Object?> get props => [message, openions];
}
