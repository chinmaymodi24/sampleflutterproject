import 'package:intl/intl.dart';

DateTime today = DateTime.now();

extension DateTimeExtension on DateTime {
  int getMonth() {
    switch (weekday) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 4;
      case 5:
        return 5;
      case 6:
        return 6;
      case 7:
        return 0;
      default:
        return 0;
    }
  }

  ///Example 2022-08-30
  String get serverDate {
    return DateFormat('yyyy-MM-dd').format(this);
  }



  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }


  ///Example 2022_08_30_12_00_00
  String get saveDate {
    return DateFormat('yyyy_MM_dd_hh_mm_ss').format(this);
  }

  ///Example 2022
  String get showYear {
    return DateFormat('yyyy').format(this);
  }

  ///Example 30-8-2022
  String get showDate {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  ///Example Aug-21
  String get shortMonthWithDate {
    return DateFormat('MMM-dd').format(this);
  }

  String get monthAndYear {
    return DateFormat('MMMM yyyy').format(this);
  }

  ///Example 20-August
  String get dateWithMonth {
    return DateFormat('dd MMMM').format(this);
  }
  ///Example 20-August-2022
  String get dateWithMonthYear {
    return DateFormat('dd-MMMM-yyyy').format(this);
  }

  ///Example Set Time In Today Date
  DateTime get realTime {
    return DateTime(today.year, today.month, today.day, hour, minute);
  }

  ///Example 12:00 AM
  String get time12Format {
    return DateFormat('hh:mm a').format(this);
  }

  ///Example 23:00
  String get time24Format {
    return DateFormat('HH:mm').format(this);
  }

  /// If date is 3/12/2022 then return 1/12/2022.
  DateTime get firstDateOfMonth {
    return DateTime(year, month, 1);
  }

  /// If date is 3/12/2022 then return 31/12/2022.
  DateTime get lastDateOfMoth {
    return (month < 12)
        ? DateTime(year, month + 1, 0)
        : DateTime(year + 1, 1, 0);
  }

  DateTime next(int day) {
    return add(Duration(days: (day - weekday) % DateTime.daysPerWeek));
  }

  bool isSameDay(DateTime? date) {
    if (date?.day == day) {
      return true;
    } else {
      return false;
    }
  }

  bool get isNotEmpty {
    if (this == null && DateTime(0).isAtSameMomentAs(this)) {
      return false;
    } else {
      return true;
    }
  }
}
