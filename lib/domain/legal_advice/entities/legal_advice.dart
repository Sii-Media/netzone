import 'package:equatable/equatable.dart';

class LegalAdvice extends Equatable {
  final String? id;
  final String text;
  final String textEn;
  final String termofUse;
  final String termofUseEn;

  const LegalAdvice({
    this.id,
    required this.text,
    required this.textEn,
    required this.termofUse,
    required this.termofUseEn,
  });

  @override
  List<Object?> get props => [id, text, textEn, termofUse, termofUseEn];
}
