String convertDateToString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String formattedDate = "${date.day}/${date.month}/${date.year}";
  return formattedDate;
}
