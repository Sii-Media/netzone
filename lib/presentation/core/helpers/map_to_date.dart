import 'package:intl/intl.dart';

String formatDate(String inputDateString) {
  DateTime inputDate = DateTime.parse(inputDateString);
  String formattedDate = DateFormat('yyyy-MM-dd').format(inputDate);
  return formattedDate;
}
