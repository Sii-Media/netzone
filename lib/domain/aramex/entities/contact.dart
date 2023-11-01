import 'package:equatable/equatable.dart';
import 'package:netzoon/data/models/aramex/contact_model.dart';

class Contact extends Equatable {
  final String? department;
  final String personName;
  final String? title;
  final String companyName;
  final String phoneNumber1;
  final String cellPhone;
  final String emailAddress;

  const Contact(
      {required this.department,
      required this.personName,
      required this.title,
      required this.companyName,
      required this.phoneNumber1,
      required this.cellPhone,
      required this.emailAddress});

  @override
  List<Object?> get props => [
        department,
        personName,
        title,
        companyName,
        phoneNumber1,
        cellPhone,
        emailAddress
      ];
}

extension MapToDomain on Contact {
  ContactModel fromDomain() => ContactModel(
      department: department,
      personName: personName,
      title: title,
      companyName: companyName,
      phoneNumber1: phoneNumber1,
      cellPhone: cellPhone,
      emailAddress: emailAddress);
}
