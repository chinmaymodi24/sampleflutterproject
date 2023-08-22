import 'package:core/utils/extensions/num_extensions.dart';

class HomeDetailModel {
  HomeDetailModel({
    required this.elgAmt,
    required this.takenLoanAmt,
    required this.takenLoanCount,
    required this.closedLoanCount,
  });

  int elgAmt;
  int takenLoanAmt;
  int takenLoanCount;
  int closedLoanCount;

  String get getElgAmt => elgAmt.toCurrency;
  String get getTakenLoanAmt => takenLoanAmt.toCurrency;

  factory HomeDetailModel.fromJson(Map<String, dynamic> json) =>
      HomeDetailModel(
        elgAmt: json["elg_amt"] ?? 0,
        takenLoanAmt: int.tryParse(json["taken_loan_amt"]?.toString() ?? "") ?? 0,
        takenLoanCount: json["taken_loan_count"] ?? 0,
        closedLoanCount: json["closed_loan_count"] ?? 0,
      );

  factory HomeDetailModel.fromEmpty() => HomeDetailModel(
        elgAmt: 0,
        takenLoanAmt: 0,
        takenLoanCount: 0,
        closedLoanCount: 0,
      );

  Map<String, dynamic> toJson() => {
        "elg_amt": elgAmt,
        "taken_loan_amt": takenLoanAmt,
        "taken_loan_count": takenLoanCount,
        "closed_loan_count": closedLoanCount,
      };
}
