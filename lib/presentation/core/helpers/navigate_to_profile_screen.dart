import 'package:flutter/material.dart';
import 'package:netzoon/presentation/categories/delivery_company/screens/delivery_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/factories/factory_profile_screen.dart';
import 'package:netzoon/presentation/categories/local_company/local_company_profile.dart';
import 'package:netzoon/presentation/categories/real_estate/screens/real_estate_company_profile_screen.dart';
import 'package:netzoon/presentation/categories/users/screens/users_profile_screen.dart';
import 'package:netzoon/presentation/categories/vehicles/screens/vehicle_companies_profile_screen.dart';

void navigateToProfileScreen(
    {required String userType,
    required String userId,
    required BuildContext context}) {
  if (userType == 'local_company') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LocalCompanyProfileScreen(id: userId);
        },
      ),
    );
  } else if (userType == 'freezone') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LocalCompanyProfileScreen(id: userId);
        },
      ),
    );
  } else if (userType == 'factory') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return FactoryProfileScreen(id: userId);
        },
      ),
    );
  } else if (userType == 'planes') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return VehicleCompaniesProfileScreen(id: userId, userType: 'planes');
        },
      ),
    );
  } else if (userType == 'car') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return VehicleCompaniesProfileScreen(id: userId, userType: 'car');
        },
      ),
    );
  } else if (userType == 'sea_companies') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return VehicleCompaniesProfileScreen(
              id: userId, userType: 'sea_companies');
        },
      ),
    );
  } else if (userType == 'user') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UsersProfileScreen(userId: userId);
        },
      ),
    );
  } else if (userType == 'real_estate') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return RealEstateCompanyProfileScreen(id: userId);
        },
      ),
    );
  } else if (userType == 'delivery_company') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DeliveryCompanyProfileScreen(id: userId);
        },
      ),
    );
  } else if (userType == 'trader') {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return LocalCompanyProfileScreen(id: userId);
        },
      ),
    );
  }
}
