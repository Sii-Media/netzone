part of 'comments_bloc.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsInitial extends CommentsState {}

class CommentsInProgress extends CommentsState {}

class CommentsSuccess extends CommentsState {
  final List<NewsComment> comments;

  const CommentsSuccess({required this.comments});

  @override
  List<Object> get props => comments;
}

class CommentsFailure extends CommentsState {
  final String message;

  const CommentsFailure({required this.message});
}
