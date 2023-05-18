part of 'add_news_bloc.dart';

abstract class AddNewsEvent extends Equatable {
  const AddNewsEvent();

  @override
  List<Object> get props => [];
}

class AddNewsRequested extends AddNewsEvent {
  final String title;
  final String description;
  final File image;
  final String ownerName;
  final String ownerImage;
  final String creator;

  const AddNewsRequested({
    required this.title,
    required this.description,
    required this.image,
    required this.ownerName,
    required this.ownerImage,
    required this.creator,
  });
}
