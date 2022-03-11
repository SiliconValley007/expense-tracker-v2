extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension OnlyDate on DateTime {
  DateTime onlyDate() => DateTime(year, month, day);
}

extension MonthOnlyCompare on DateTime {
  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;
}

extension MoneyFormat on double {
  String toMoney() {
    String amount = toStringAsFixed(2);
    String onlyDecimal = amount.substring(amount.length - 2);
    String onlyAmount = amount.substring(0, amount.length - 3);

    if (onlyAmount.length > 3) {
      if (onlyAmount.substring(onlyAmount.length - 3) == '000') {
        if (onlyDecimal == '00') {
          return '₹${onlyAmount.substring(0, onlyAmount.length - 3)}k';
        }
        return '₹${onlyAmount.substring(0, onlyAmount.length - 3)}k ${onlyDecimal}p';
      }
      return '₹$amount';
    }
    return '₹$amount';
  }
}
