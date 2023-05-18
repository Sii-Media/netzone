import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String text;

  const Question({required this.text});
  @override
  List<Object?> get props => [text];
}
