part of 'real_estate_bloc.dart';

abstract class RealEstateEvent extends Equatable {
  const RealEstateEvent();

  @override
  List<Object> get props => [];
}

class GetAllRealEstatesEvent extends RealEstateEvent {}

class GetRealEstateCompaniesEvent extends RealEstateEvent {}

class GetCompanyRealEstatesEvent extends RealEstateEvent {
  final String id;

  const GetCompanyRealEstatesEvent({required this.id});
}

class AddRealEstateEvent extends RealEstateEvent {
  final String title;
  final File image;
  final String description;
  final int price;
  final int area;
  final String location;
  final int bedrooms;
  final int bathrooms;
  final List<String>? amenities;
  final List<XFile>? realestateimages;

  const AddRealEstateEvent({
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.area,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    this.amenities,
    this.realestateimages,
  });
}
