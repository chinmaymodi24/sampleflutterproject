import 'package:admin/module/test/test_page_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/widget/custom_button.dart';
import 'package:core/widget/custom_filled_textfield.dart';

class TestPage extends StatelessWidget {
  final TestPageCtrl c = Get.put(TestPageCtrl());
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Calculation Test Page')),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Form(
            key: formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: FilledTextField(
                    controller: c.amountCTRL,
                    hint: 'Amount',
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter amount';
                      } else if (int.tryParse(v.trim()) == null) {
                        return 'Enter valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 300,
                  child: FilledTextField(
                    controller: c.interestCTRL,
                    hint: 'Interest',
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter interest';
                      } else if (int.tryParse(v.trim()) == null) {
                        return 'Enter valid interest';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 300,
                  child: FilledTextField(
                    controller: c.durationCTRL,
                    hint: 'Duration',
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Enter duration';
                      } else if (int.tryParse(v.trim()) == null) {
                        return 'Enter valid duration';
                      }
                      return null;
                    },
                  ),
                ),
                // SizedBox(
                //   width: 300,
                //   child: FilledTextField(
                //     controller: c.emiCTRL,
                //     hint: 'Pay Every Month',
                //     validator: (v) {
                //       if (v == null || v.isEmpty) {
                //         return 'Enter pay amount';
                //       } else if (int.tryParse(v.trim()) == null) {
                //         return 'Enter valid pay amount';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: CustomButton(
              text: 'Create',
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  c.onPress();
                }
              },
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                'month',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                'amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                'interestAmount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                'pay',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                'balance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: c.list.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var model = c.list[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      model.amount.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      model.interestAmount.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 250,
                      child: FilledTextField(
                        controller: model.payCTRL,
                        hint: 'Pay',
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return null;
                          } else if (int.tryParse(v.trim()) == null) {
                            return 'Enter valid amount';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              c.updateList();
                            }),
                      ),
                    ),
                    Text(
                      model.balance.toString(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
