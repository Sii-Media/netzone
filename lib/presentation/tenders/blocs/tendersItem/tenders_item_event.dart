part of 'tenders_item_bloc.dart';

abstract class TendersItemEvent extends Equatable {
  const TendersItemEvent();

  @override
  List<Object> get props => [];
}

class GetTendersItemEvent extends TendersItemEvent {
  const GetTendersItemEvent();
}

class GetTendersItemByMinEvent extends TendersItemEvent {
  final String category;

  const GetTendersItemByMinEvent({required this.category});
}

class GetTendersItemByMaxEvent extends TendersItemEvent {
  final String category;

  const GetTendersItemByMaxEvent({required this.category});
}

class AddTenderEvent extends TendersItemEvent {
  final String nameAr;
  final String nameEn;
  final String companyName;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final File tenderImage;
  final String category;

  const AddTenderEvent({
    required this.nameAr,
    required this.nameEn,
    required this.companyName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.tenderImage,
    required this.category,
  });
}
