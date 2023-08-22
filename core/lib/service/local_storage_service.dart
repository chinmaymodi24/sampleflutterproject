import 'dart:developer';
import 'package:core/model/user_model.dart';
import 'package:core/service/local_store.dart';
import 'package:core/styles/app_themes.dart';

class LocalStorageService {
  static UserModel? get getLogin {
    var model = LocalStore.get("login");
    logger.i("getLogin ------- $model");
    log("getLogin = ${model}");
    if (model is Map<String, dynamic>) {
      return UserModel.fromJson(model);
    }
    return null;
  }

  static setLogin(UserModel userToken) {
    log("setLogin = $userToken");
    LocalStore.set("login", userToken.toJson());
  }

  static get getEmail {
    String? mode = LocalStore.get("email");
    log("getEmail = $mode");
    return mode;
  }

  static setEmail({required String value}) {
    LocalStore.set("email", value);
  }

  static get getLanguage {
    String? mode = LocalStore.get("language");
    log("getLanguage = $mode");
    return mode;
  }

  static setLanguage({required String value}) {
    LocalStore.set("language", value);
  }

  static get getIsAppFirstTime {
    String? mode = LocalStore.get("isapp");
    log("getLanguage = $mode");
    return mode;
  }

  static get isFirst {
    var mode = LocalStore.get("isFirst");
    log("getLanguage = $mode");
    return mode;
  }

  static setIsFirstTime({required String? value}) {
    LocalStore.set("isFirst", value);
  }


  static setIsAppFirstTime({required String? value}) {
    LocalStore.set("isapp", value);
  }



  static get getAdminLogin {
    Map<String, dynamic>? mode = LocalStore.get("login");
    log("mode = $mode");
    return mode;
  }

  static setAdminLogin(Map<String, dynamic> userToken) {
    log("userToken = $userToken");
    LocalStore.set("login", userToken);
  }

  static removeLogin() {
    LocalStore.remove("login");
  }
}
