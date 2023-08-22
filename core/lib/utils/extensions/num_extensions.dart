import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension Formatte on int {
  String get weekName {
    switch (this) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
      default:
        return '';
    }
  }

  String get monthName {
    switch (this) {
      case 1:
        return 'jan'.tr;
      case 2:
        return 'feb'.tr;
      case 3:
        return 'mar'.tr;
      case 4:
        return 'apr'.tr;
      case 5:
        return 'may'.tr;
      case 6:
        return 'jun'.tr;
      case 7:
        return 'jul'.tr;
      case 8:
        return 'aug'.tr;
      case 9:
        return 'sep'.tr;
      case 10:
        return 'oct'.tr;
      case 11:
        return 'nov'.tr;
      case 12:
        return 'dec'.tr;
      default:
        return '';
    }
  }

  String get alphaBets {
    return String.fromCharCode(this + 65);
  }
}

extension FancyNum on num {
  num plus(num other) => this + other;

  num times(num other) => this * other;

  num get percentageOf10 => (this * 10) / 100;

  String get toCurrency {
    var format = NumberFormat("#,##0");
    return format.format(this);
  }
}
