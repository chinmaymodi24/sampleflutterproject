import 'package:get_storage/get_storage.dart';

class LocalStore{
  static final pref = GetStorage();
  static get(String key){
    return pref.read(key);
  }
  static set(String key,var data)async{
    await pref.write(key, data);
  }
  static remove(String key)async{
    await pref.remove(key);
  }
}