part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsInProgress extends NewsState {}

class NewsSuccess extends NewsState {
  final List<News> news;
  final User? currentUser;
  const NewsSuccess({
    required this.news,
    this.currentUser,
  });

  @override
  List<Object> get props => [news, currentUser!];
}

class NewsFailure extends NewsState {
  final String message;

  const NewsFailure({required this.message});
}

class ToggleonlikeSuccess extends NewsState {}

class GetNewsByIdSuccess extends NewsState {
  final News news;

  const GetNewsByIdSuccess({required this.news});
}

class GetCompanyNewsSuccess extends NewsState {
  final List<News> news;

  const GetCompanyNewsSuccess({required this.news});
}

class EditNewsInProgress extends NewsState {}

class EditNewsFailure extends NewsState {
  final String message;

  const EditNewsFailure({required this.message});
}

class EditNewsSuccess extends NewsState {
  final String news;

  const EditNewsSuccess({required this.news});
}

class DeleteNewsInProgress extends NewsState {}

class DeleteNewsFailure extends NewsState {
  final String message;

  const DeleteNewsFailure({required this.message});
}

class DeleteNewsSuccess extends NewsState {
  final String message;
  final List<News> updatedNews;
  const DeleteNewsSuccess({
    required this.message,
    required this.updatedNews,
  });
}
