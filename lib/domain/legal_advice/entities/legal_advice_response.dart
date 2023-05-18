import 'package:equatable/equatable.dart';
import 'package:netzoon/domain/legal_advice/entities/legal_advice.dart';

class LegalAdviceResponse extends Equatable {
  final String message;
  final List<LegalAdvice> legalAdvices;

  const LegalAdviceResponse(
      {required this.message, required this.legalAdvices});
  @override
  List<Object?> get props => [message, legalAdvices];
}
