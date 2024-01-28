import 'package:crm_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future storeLocalSetEmployeeID(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future storeLocalSetLogInStatus(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future storeLocalSetEmployeeName(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future storeLocalSetEmployeeContact(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future storeLocalSetEmployeeSBU(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future storeLocalSetEmployeeEmail(String key, String value) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await sharedPreferences.setString(key, value);
}

Future<bool> getLocalLoginStatus() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.logInStatusKey);
  print('checked status =>$value');
  if (value == 'success') {
    return true;
  } else {
    return false;
  }
  //return value !=null?true:false;
}

Future<String> getLocalEmployeeID() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.employeeIDKey);
  return value.toString();
}

Future<String> getLocalEmployeeName() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.employeeNameKey);
  return value.toString();
}

Future<String> getLocalEmployeeSBU() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.employeeSBUKey);
  return value.toString();
}

Future<String> getLocalEmployeeContact() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.employeeContactKey);
  return value.toString();
}

Future<String> getLocalEmployeeEmail() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  var value = sharedPreferences.getString(Constants.employeeEmailKey);
  return value.toString();
}
