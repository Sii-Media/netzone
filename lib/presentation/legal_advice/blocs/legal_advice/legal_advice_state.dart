part of 'legal_advice_bloc.dart';

abstract class LegalAdviceState extends Equatable {
  const LegalAdviceState();

  @override
  List<Object> get props => [];
}

class LegalAdviceInitial extends LegalAdviceState {}

class LegalAdviceProgress extends LegalAdviceState {}

class LegalAdviceSuccess extends LegalAdviceState {
  final List<LegalAdvice> legalAdvices;

  const LegalAdviceSuccess({required this.legalAdvices});
}

class LegalAdviceFailure extends LegalAdviceState {
  final String message;

  const LegalAdviceFailure({required this.message});
}
