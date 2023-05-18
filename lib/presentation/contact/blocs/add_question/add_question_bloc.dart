import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/questions/entities/question.dart';
import 'package:netzoon/domain/questions/usecases/add_question_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

part 'add_question_event.dart';
part 'add_question_state.dart';

class AddQuestionBloc extends Bloc<AddQuestionEvent, AddQuestionState> {
  final AddQuestionUseCase addQuestionUseCase;
  AddQuestionBloc({required this.addQuestionUseCase})
      : super(AddQuestionInitial()) {
    on<PostQuestionEvent>((event, emit) async {
      emit(AddQuestionInProgress());
      final failureOrQuestion =
          await addQuestionUseCase(AddQuestionParams(text: event.text));

      emit(
        failureOrQuestion.fold(
          (failure) => AddQuestionFailure(message: mapFailureToString(failure)),
          (question) => AddQuestionSuccess(question: question.question),
        ),
      );
    });
  }
}
