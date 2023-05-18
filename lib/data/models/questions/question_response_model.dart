import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/data/models/questions/question_model.dart';
import 'package:netzoon/domain/questions/entities/question_response.dart';

part 'question_response_model.g.dart';

@JsonSerializable()
class QuestionResponseModel {
  final String message;

  @JsonKey(name: 'results')
  final QuestionModel questionModel;

  QuestionResponseModel({required this.message, required this.questionModel});

  factory QuestionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionResponseModelToJson(this);
}

extension MapToDomain on QuestionResponseModel {
  QuestionResponse toDomain() => QuestionResponse(
        message: message,
        question: questionModel.toDomain(),
      );
}
