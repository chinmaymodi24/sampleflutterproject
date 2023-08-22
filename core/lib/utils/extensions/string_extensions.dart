import 'package:intl/intl.dart';

extension StringExtensions on String {
  List<String> get splitString {
    return split('|');
  }

  DateTime get showDateTime {
    return DateFormat('dd-MM-yyyy').parse(this);
  }

  DateTime get timeDateTime {
    return DateFormat('hh:mm a').parse(this);
  }

  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }

  double? get getWavePercentage {
    var per = double.parse(this);
    return double.parse(((92 - per) / 100).toStringAsFixed(2));
  }
}
