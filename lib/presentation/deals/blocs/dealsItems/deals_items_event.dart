part of 'deals_items_bloc.dart';

abstract class DealsItemsEvent extends Equatable {
  const DealsItemsEvent();

  @override
  List<Object> get props => [];
}

class DealsItemsByCatEvent extends DealsItemsEvent {
  final String category;
  final String? companyName;
  final int? minPrice;
  final int? maxPrice;
  const DealsItemsByCatEvent({
    required this.category,
    this.companyName,
    this.minPrice,
    this.maxPrice,
  });
}

class GetDealsItemEvent extends DealsItemsEvent {}

class AddDealEvent extends DealsItemsEvent {
  final String name;
  final String companyName;
  final File dealImage;
  final int prevPrice;
  final int currentPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final String description;
  const AddDealEvent({
    required this.name,
    required this.companyName,
    required this.dealImage,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.description,
  });
}

class GetDealByIdEvent extends DealsItemsEvent {
  final String id;

  const GetDealByIdEvent({required this.id});
}

class DeleteDealEvent extends DealsItemsEvent {
  final String id;

  const DeleteDealEvent({required this.id});
}

class EditDealEvent extends DealsItemsEvent {
  final String id;
  final String name;
  final String companyName;
  final File? dealImage;
  final int prevPrice;
  final int currentPrice;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;
  final String country;
  final String description;
  const EditDealEvent({
    required this.id,
    required this.name,
    required this.companyName,
    required this.dealImage,
    required this.prevPrice,
    required this.currentPrice,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
    required this.country,
    required this.description,
  });
}

class GetUserDealsEvent extends DealsItemsEvent {
  final String userId;

  const GetUserDealsEvent({required this.userId});
}

class PurchaseDealEvent extends DealsItemsEvent {
  final String userId;
  final String deal;
  final double grandTotal;

  const PurchaseDealEvent(
      {required this.userId, required this.deal, required this.grandTotal});
}
