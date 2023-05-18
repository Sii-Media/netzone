import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/questions/entities/question.dart';

part 'question_model.g.dart';

@JsonSerializable()
class QuestionModel {
  @JsonKey(name: '_id')
  final String? id;
  final String text;

  QuestionModel({this.id, required this.text});

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

extension MapToDomain on QuestionModel {
  Question toDomain() => Question(text: text);
}
