part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsEvent extends CommentsEvent {
  final String newsId;

  const GetCommentsEvent({required this.newsId});
}

class AddCommentEvent extends CommentsEvent {
  final String newsId;

  final String text;

  const AddCommentEvent({required this.newsId, required this.text});
}
