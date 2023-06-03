import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netzoon/domain/core/usecase/usecase.dart';
import 'package:netzoon/domain/news/entities/news_comment.dart';
import 'package:netzoon/domain/news/usecases/add_comment_use_case.dart';
import 'package:netzoon/domain/news/usecases/get_comments_use_case.dart';
import 'package:netzoon/presentation/core/helpers/map_failure_to_string.dart';

import '../../../../domain/auth/entities/user.dart';
import '../../../../domain/auth/usecases/get_signed_in_user_use_case.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final GetSignedInUserUseCase getSignedInUser;
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;
  CommentsBloc(
    this.getSignedInUser, {
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
  }) : super(CommentsInitial()) {
    on<GetCommentsEvent>((event, emit) async {
      emit(CommentsInProgress());

      final comments = await getCommentsUseCase(event.newsId);

      emit(
        comments.fold(
          (failure) => CommentsFailure(message: mapFailureToString(failure)),
          (comments) => CommentsSuccess(comments: comments),
        ),
      );
    });
    on<AddCommentEvent>((event, emit) async {
      emit(CommentsInProgress());
      final result = await getSignedInUser.call(NoParams());
      late User user;
      result.fold((l) => null, (r) => user = r!);
      // final List<NewsComment> updatedComments =
      //     List<NewsComment>.from(state.props)
      //       ..add(NewsComment(user: user.userInfo, text: event.text));
      final response = await addCommentUseCase(AddCommentParams(
          newsId: event.newsId, userId: user.userInfo.id, text: event.text));

      if (response.isRight()) {
        final comments = await getCommentsUseCase(event.newsId);
        emit(
          comments.fold(
            (failure) => CommentsFailure(message: mapFailureToString(failure)),
            (comments) => CommentsSuccess(comments: comments),
          ),
        );
      }
    });
  }
}
