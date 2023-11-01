import 'package:json_annotation/json_annotation.dart';
import 'package:netzoon/domain/aramex/entities/contact.dart';

part 'contact_model.g.dart';

@JsonSerializable(createToJson: true)
class ContactModel {
  @JsonKey(name: 'Department')
  final String? department;
  @JsonKey(name: 'PersonName')
  final String personName;
  @JsonKey(name: 'Title')
  final String? title;
  @JsonKey(name: 'CompanyName')
  final String companyName;
  @JsonKey(name: 'PhoneNumber1')
  final String phoneNumber1;
  @JsonKey(name: 'CellPhone')
  final String cellPhone;
  @JsonKey(name: 'EmailAddress')
  final String emailAddress;

  ContactModel(
      {required this.department,
      required this.personName,
      required this.title,
      required this.companyName,
      required this.phoneNumber1,
      required this.cellPhone,
      required this.emailAddress});

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}

extension MapToDomain on ContactModel {
  Contact toDomain() => Contact(
        department: department,
        personName: personName,
        title: title,
        companyName: companyName,
        phoneNumber1: phoneNumber1,
        cellPhone: cellPhone,
        emailAddress: emailAddress,
      );
}
