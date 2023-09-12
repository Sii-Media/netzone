import 'package:netzoon/domain/departments/entities/category_products/category_products.dart';

double calculatePurchaseFee(double amount) {
  double fee;
  if (amount >= 1000) {
    fee = 10;
  } else if (amount > 100 && amount < 1000) {
    fee = 5;
  } else {
    fee = 0;
  }
  return fee;
}

double calculateTraderFee({
  required List<CategoryProducts> items,
}) {
  double fee = 0;
  for (int i = 0; i < items.length; i++) {
    final itemQuan = items[i].quantity ?? 1;
    if (items[i].owner.userType == 'factory' ||
        items[i].owner.userType == 'freezone') {
      fee += ((items[i].price * 3) / 100) * itemQuan;
    }
  }
  return fee;
}

double calulateAddProductFee(
    {required int price, required int quantity, required String? isNew}) {
  double fee;
  if (isNew == 'new') {
    //fee = ((7 * price) / 100) * quantity;
    fee = 5.0 * quantity;
  } else {
    // fee = (((7 * price) / 100) + 10) * quantity;
    fee = 10.0 * quantity;
  }
  return fee;
}

double calculateDealsFee({
  required int price,
}) {
  double fee;
  fee = (5 * price) / 100;
  return fee;
}
