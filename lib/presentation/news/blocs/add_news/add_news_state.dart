part of 'add_news_bloc.dart';

abstract class AddNewsState extends Equatable {
  const AddNewsState();

  @override
  List<Object> get props => [];
}

class AddNewsInitial extends AddNewsState {}

class AddNewsInProgress extends AddNewsState {}

class AddNewsSuccess extends AddNewsState {
  final String news;

  const AddNewsSuccess({required this.news});
}

class AddNewsFailure extends AddNewsState {
  final String message;

  const AddNewsFailure({required this.message});
}
