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

  const NewsSuccess({required this.news});
}

class NewsFailure extends NewsState {
  final String message;

  const NewsFailure({required this.message});
}
