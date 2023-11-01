import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String convertDateToString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String formattedDate = "${date.day}/${date.month}/${date.year}";
  return formattedDate;
}

String formatDateTime(String dateString) {
  initializeDateFormatting();

  final inputDate = DateTime.parse(dateString);

  final formatter = DateFormat('dd/MM/yyyy hh:mm a');
  final formattedDate = formatter.format(inputDate);

  return formattedDate;
}
