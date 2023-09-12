import 'package:equatable/equatable.dart';

class LegalAdvice extends Equatable {
  final String? id;
  final String text;
  final String textEn;

  const LegalAdvice({
    this.id,
    required this.text,
    required this.textEn,
  });

  @override
  List<Object?> get props => [id, text, textEn];
}
