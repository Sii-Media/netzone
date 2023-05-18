part of 'legal_advice_bloc.dart';

abstract class LegalAdviceEvent extends Equatable {
  const LegalAdviceEvent();

  @override
  List<Object> get props => [];
}

class GetLegalAdviceEvent extends LegalAdviceEvent {}
