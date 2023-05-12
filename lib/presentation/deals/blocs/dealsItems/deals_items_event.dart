part of 'deals_items_bloc.dart';

abstract class DealsItemsEvent extends Equatable {
  const DealsItemsEvent();

  @override
  List<Object> get props => [];
}

class DealsItemsByCatEvent extends DealsItemsEvent {
  final String category;

  const DealsItemsByCatEvent({required this.category});
}
