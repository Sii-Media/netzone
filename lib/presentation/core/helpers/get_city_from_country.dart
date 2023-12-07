import 'package:netzoon/presentation/data/cities.dart';

List<String> getCitiesFromCountry({required String country}) {
  switch (country) {
    case 'AE':
      return cities;
    case 'EG':
      return egCities;
    case 'JO':
      return jdCities;
    case 'IQ':
      return iqCities;
    case 'SA':
      return saCities;
    default:
      return cities;
  }
}
