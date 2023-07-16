import 'package:netzoon/presentation/utils/app_localizations.dart';

String getCurrencyFromCountry(String country, context) {
  switch (country) {
    case 'AE':
      return AppLocalizations.of(context).translate('AED');
    case 'EG':
      return AppLocalizations.of(context).translate('EGP');
    case 'JO':
      return AppLocalizations.of(context).translate('JOD');
    case 'IQ':
      return AppLocalizations.of(context).translate('IQD');
    case 'SA':
      return AppLocalizations.of(context).translate('SAR');
    default:
      return '\$';
  }
}
