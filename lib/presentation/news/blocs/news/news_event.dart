part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetAllNewsEvent extends NewsEvent {}

class ToggleonlikeEvent extends NewsEvent {
  final String newsId;

  const ToggleonlikeEvent({required this.newsId});
}

class UserLikedNewsEvent extends NewsEvent {}

class GetNewsByIdEvent extends NewsEvent {
  final String id;

  const GetNewsByIdEvent({required this.id});
}

class GetCompanyNewsEvent extends NewsEvent {
  final String id;

  const GetCompanyNewsEvent({required this.id});
}
