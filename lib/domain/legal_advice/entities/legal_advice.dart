import 'package:equatable/equatable.dart';

class LegalAdvice extends Equatable {
  final String? id;
  final String text;

  const LegalAdvice({this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}
