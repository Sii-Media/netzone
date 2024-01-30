int calculateTotalAdsPrice(
    {required String? selectedStartDate, required String? SelectedendDate}) {
  if (selectedStartDate != null && SelectedendDate != null) {
    DateTime startDate = DateTime.parse(selectedStartDate);
    DateTime endDate = DateTime.parse(SelectedendDate);
    Duration difference = endDate.difference(startDate);
    int totalPrice = difference.inDays * 5;
    return totalPrice;
  } else {
    return 0;
  }
}
