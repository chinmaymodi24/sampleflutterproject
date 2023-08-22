import 'package:admin/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TestPageCtrl extends GetxController {
  final TextEditingController amountCTRL = TextEditingController(text: '5000');
  final TextEditingController interestCTRL = TextEditingController(text: '8');
  final TextEditingController durationCTRL = TextEditingController(text: '6');
  RxList<LoanModel> list = <LoanModel>[].obs;

  void onPress() async {
    list.clear();
    int amount = int.parse(amountCTRL.text.trim());
    int interest = int.parse(interestCTRL.text.trim());
    int duration = int.parse(durationCTRL.text.trim());

    for (var i = 0; i < duration; i++) {
      try {
        var newAmount = (i == 0) ? amount : list[i - 1].balance;
        var newInterest = findInterest(newAmount, interest);
        list.add(
          LoanModel(
            amount: newAmount,
            interestAmount: newInterest,
            pay: 0,
            balance: (newAmount + newInterest) - 0,
            payCTRL: TextEditingController(),
          ),
        );
      } on Exception catch (e, t) {
        logger.e('ERROR :$e \nTRACE :$t', 'INDEX :$i');
      }
    }
  }

  void updateList() async {
    int amount = int.parse(amountCTRL.text.trim());
    int interest = int.parse(interestCTRL.text.trim());

    for (var i = 0; i < list.length; i++) {
      try {
        var model = list[i];
        var newAmount = (i == 0) ? amount : list[i - 1].balance;
        var newInterest = findInterest(newAmount, interest);
        var pay = int.tryParse(model.payCTRL.text) ?? 0;
        var newBalance = (newAmount + newInterest) - pay;
        if (newAmount >= 0) {
          list[i] = LoanModel(
            amount: newAmount,
            interestAmount: newInterest,
            pay: pay,
            balance: (newAmount + newInterest) - pay,
            payCTRL: TextEditingController(text: '${pay != 0 ? pay : ''}'),
          );
        } else {
          list[i] = LoanModel(
            amount: 0,
            interestAmount: 0,
            pay: 0,
            balance: 0,
            payCTRL: TextEditingController(),
          );
        }
      } on Exception catch (e, t) {
        logger.e('ERROR :$e \nTRACE :$t', 'INDEX :$i');
      }
    }
    list.refresh();
  }

  int findInterest(int amount, int interest) {
    // int interest = int.tryParse(interestCTRL.text.trim()) ?? 0;
    var interestAmount = (amount * interest) / 100;
    return interestAmount.toInt();
  }
}

/// FIND INTEREST FROM AMOUNT
/// THEN REDUCE PAID AMOUNT
/// FIND BALANCE = (AMOUNT +INTEREST) - PAID AMOUNT;

class LoanModel {
  // final DateTime loanDate;
  final int amount;
  final int interestAmount;
  final int pay;
  final int balance;
  final TextEditingController payCTRL;

  LoanModel({
    // required this.loanDate,
    required this.amount,
    required this.interestAmount,
    required this.pay,
    required this.balance,
    required this.payCTRL,
  });
}
