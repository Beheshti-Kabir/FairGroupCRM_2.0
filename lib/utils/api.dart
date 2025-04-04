import 'dart:convert';

import 'package:crm_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

getFollowUpData() async {
  DateTime now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String searchDate = formatter.format(now);

  String localURL = Constants.globalURL;
  var response = await http.post(Uri.parse('$localURL/getFollowUpInfo'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'userID': Constants.employeeId,
        'searchDate': searchDate,
        'allSearch': 'FALSE'
      }));

  return jsonDecode(response.body)['leadList'];
}

getData() async {
  String localURL = Constants.globalURL;
  List professionList = [''];
  List paymentMethodList = [''];
  List salesPersonList = [''];
  List leadSourceList = [''];
  List leadStatusList = [''];
  List modelList = [''];
  List leadProspectTypeList = [''];
  List followUpModeList = [''];
  List verticalList = [''];

  List<dynamic> returnList = [];
  var response = await http.post(Uri.parse('$localURL/getDataNew'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'userID': Constants.employeeId,
      }));

  print('industryTypeList=========' +
      json.decode(response.body)['industryTypeList'].toString());

  var followupModeJSON = json.decode(response.body)['followupModeList'];
  int followupModeNumber = followupModeJSON.length;
  for (int i = 0; i < followupModeNumber; i++) {
    followUpModeList.insert(i + 1, followupModeJSON[i]['name']);
  }
  returnList.insert(0, followUpModeList);

  var modelJSON = json.decode(response.body)['modelList'];
  int modelNumber = modelJSON.length;
  for (int i = 0; i < modelNumber; i++) {
    modelList.insert(i + 1, modelJSON[i].toString());
  }
  returnList.insert(0, modelList);

  var verticalJSON = json.decode(response.body)['industryTypeList'];
  int verticalNumber = verticalJSON.length;
  for (int i = 0; i < verticalNumber; i++) {
    verticalList.insert(i + 1, verticalJSON[i]['name']);
  }
  returnList.insert(0, verticalList);

  var professionJSON = json.decode(response.body)['professionList'];
  int professionNumber = professionJSON.length;
  for (int i = 0; i < professionNumber; i++) {
    professionList.insert(i + 1, professionJSON[i]['name']);
  }
  returnList.insert(0, professionList);

  var paymentMethodJSON = json.decode(response.body)['payModeList'];
  int paymentMethodNumber = paymentMethodJSON.length;
  for (int i = 0; i < paymentMethodNumber; i++) {
    paymentMethodList.insert(i + 1, paymentMethodJSON[i]['name']);
  }
  returnList.insert(0, paymentMethodList);

  var salesPersonJSON = json.decode(response.body)['salesPersonList'];
  int salesPersonNumber = salesPersonJSON.length;
  for (int i = 0; i < salesPersonNumber; i++) {
    salesPersonList.insert(i + 1,
        '${salesPersonJSON[i]['empCode']} ${salesPersonJSON[i]['empName']}');
  }
  returnList.insert(0, salesPersonList);

  var leadSourceJSON = json.decode(response.body)['leadSourceList'];
  int leadSourceNumber = leadSourceJSON.length;
  for (int i = 0; i < leadSourceNumber; i++) {
    leadSourceList.insert(i + 1, leadSourceJSON[i]['name']);
  }
  returnList.insert(0, leadSourceList);

  var leadStatusJSON = json.decode(response.body)['leadStatList'];
  int leadSatusNumber = leadStatusJSON.length;
  for (int i = 0; i < leadSatusNumber; i++) {
    leadStatusList.insert(i + 1, leadStatusJSON[i]['name']);
    leadProspectTypeList.insert(i + 1, leadStatusJSON[i]['keyValue']);
  }
  returnList.insert(0, leadStatusList);
  returnList.insert(8, leadProspectTypeList);
  print('test=============' + returnList[0].toString());
  print('test=============' + returnList[1].toString());
  print('test=============' + returnList[2].toString());
  print('test=============' + returnList[3].toString());
  print('test=============' + returnList[4].toString());
  print('test=============' + returnList[5].toString());
  print('test=============' + returnList[6].toString());
  print('test=============' + returnList[7].toString());
  print('test=============' + returnList[8].toString());
  return returnList;
  // [[leadStatusList],[leadSourceList],[salesPersonList],[paymentMethodList],[professionList],
  // [verticalList],[modelList],[followUpModeList],[leadProspectTypeList]]
}

getLeadSearchData(
  String customerName,
  String phoneNumber,
  String companyName,
  String leadNo,
  String stepType,
  String toDate,
  String fromDate,
  String allSearch,
  String testDriveStatus,
) async {
  String localURL = Constants.globalURL;
  var response = await http.post(Uri.parse('$localURL/getDataByStatus'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'userID': Constants.employeeId,
        'phoneNo': phoneNumber,
        'companyName': companyName,
        'customerName': customerName,
        'allSearch': allSearch,
        'leadNo': leadNo,
        'stepType': stepType,
        'toDate': toDate,
        'fromDate': fromDate,
        'testDriveApprovalStatus': testDriveStatus
      }));

  var statusValue = jsonDecode(response.body)['leadList'];

  print(statusValue.toString());
  return statusValue;
}

getLeadProduct(String leadNo) async {
  String localURL = Constants.globalURL;
  var response = await http.post(Uri.parse('$localURL/getProductDataByLeadNo'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'leadNo': leadNo,
      }));

  return jsonDecode(response.body)['leadProductList'];
}

getDSIFormList(String roNo) async {
  String localURL = Constants.dsiGlobalURL;
  var response = await http.post(Uri.parse('$localURL/getDsiListByJobNo'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'roNo': roNo,
      }));
  print(jsonDecode(response.body).toString());

  return jsonDecode(response.body)['dsiList'];
}
