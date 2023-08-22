import 'package:core/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final AppRepo app = AppRepo();

class AppRepo {
  static final AppRepo _instance = AppRepo._();

  AppRepo._();

  factory AppRepo() => _instance;

  Rx<UserModel> userModel = UserModel.fromEmpty().obs;

  UserModel get user => userModel.value;

  RxString phoneNumber = "".obs;
  RxString countryCode = "1".obs;

  get getCurrentUserUid => FirebaseAuth.instance.currentUser?.uid;

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

//Rx<UserModel> userModel = UserModel.fromEmpty().obs;
}
