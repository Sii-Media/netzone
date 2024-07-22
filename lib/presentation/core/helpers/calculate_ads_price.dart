double calculateTotalAdsPrice(
    {required String? selectedStartDate,
    required String? selectedendDate,
    required double value}) {
  if (selectedStartDate != null && selectedendDate != null) {
    DateTime startDate = DateTime.parse(selectedStartDate);
    DateTime endDate = DateTime.parse(selectedendDate);
    Duration difference = endDate.difference(startDate);
    double totalPrice = difference.inDays * value;
    return totalPrice;
  } else {
    return 0;
  }
}
