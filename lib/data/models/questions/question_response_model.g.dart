// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionResponseModel _$QuestionResponseModelFromJson(
        Map<String, dynamic> json) =>
    QuestionResponseModel(
      message: json['message'] as String,
      questionModel:
          QuestionModel.fromJson(json['results'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionResponseModelToJson(
        QuestionResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'results': instance.questionModel,
    };
