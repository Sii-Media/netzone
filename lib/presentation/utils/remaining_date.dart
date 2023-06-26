int calculateRemainingDays(String endDateStr) {
  DateTime endDate = DateTime.parse(endDateStr);
  DateTime now = DateTime.now();
  int remainingDays = endDate.difference(now).inDays;
  return remainingDays;
}
