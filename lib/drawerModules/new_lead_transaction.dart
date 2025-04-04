import 'dart:convert';

import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class NewLeadTransactionModule extends StatefulWidget {
  const NewLeadTransactionModule({Key? key}) : super(key: key);

  @override
  State<NewLeadTransactionModule> createState() =>
      _NewLeadTransactionModuleState();
}

class _NewLeadTransactionModuleState extends State<NewLeadTransactionModule> {
  String employID = '';
  final phoneNumberController = TextEditingController();
  final leadNoController = TextEditingController();
  final companyNameController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerDOBController = TextEditingController();
  final followUpModeController = TextEditingController();
  final followUpDescriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final nextFollowUpDateController = TextEditingController();
  final leadStatusController = TextEditingController();
  final leadProspectTypeController = TextEditingController();
  final remarksController = TextEditingController();
  final cancelReasonController = TextEditingController();
  final lostToWhomController = TextEditingController();
  final modelNameController = TextEditingController();
  final modelNameControllerMid = TextEditingController();
  final requestedTestDriveTimeController = TextEditingController();
  final requestedTestDriveDateController = TextEditingController();
  final requestedTestDriveDateTimeController = TextEditingController();
  final testdriveStatus = TextEditingController();
  final testDriveApprovalStatus = TextEditingController();
  final isFinanceController = TextEditingController();

  List followUpModeList = [''];
  List leadStatusList = [''];
  List leadProspectTypeList = [''];
  List modelList = [''];
  List cancelReasonList = [
    'Not interested Anymore',
    'Lost to Competitor',
    'Financial issue',
    'Better Offer from Competitor',
    'Product Not Available',
    ''
  ];
  List isFinanceList = [
    '',
    'YES',
    'NO',
  ];
  bool isPressed = false;

  @override
  initState() {
    Constants.selectedSearhed = false;
    super.initState();
    getLocation();
    getEmployInfo();
  }

  var long = "longitude";
  var lat = "latitude";

  getEmployInfo() async {
    employID = await getLocalEmployeeID();
    var data = await getData();
    // [[leadStatusList],[leadSourceList],[salesPersonList],[paymentMethodList],[professionList],
    // [verticalList],[modelList],[followUpModeList],[leadProspectTypeList]]
    followUpModeList = data[7];
    leadStatusList = data[0];
    leadProspectTypeList = data[8];
    modelList = data[6];

    setState(() {});
  }

  refresh() async {
    customerNameController.text = Constants.selectedCustomerName;
    leadNoController.text = Constants.selectedLeadNo;
    phoneNumberController.text = Constants.selectedPhoneNumber;
    customerDOBController.text = '';
    setState(() {});
  }

  void getLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      getPermission();
    } else {
      await serviceEnable();
      if (await Geolocator.isLocationServiceEnabled()) {
        getPermission();
      } else {
        // Navigator.of(context).pop();
        print('TURN ON LOCATION');
      }

      //getLocation();
    }
  }

  Future serviceEnable() async {
    await Geolocator.openLocationSettings();
  }

  void getPermission() async {
    LocationPermission per1 = await Geolocator.checkPermission();
    print('permision 1 = $per1');
    if (per1 == LocationPermission.denied ||
        per1 == LocationPermission.deniedForever) {
      print("permission denied");
      LocationPermission per2 = await Geolocator.requestPermission();
      print('permision 2 = $per2');
      if (per2 == LocationPermission.denied ||
          per2 == LocationPermission.deniedForever) {
        print("permission denied-2");
        Navigator.of(context).pushReplacementNamed('/landingPage');
      }
    } else {
      Position currentLoc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        long = currentLoc.longitude.toString();
        lat = currentLoc.latitude.toString();
      });
    }
  }

  Future<String> saveNewLeadTransaction() async {
    String employIDD = await getLocalEmployeeID();
    String localURL = Constants.globalURL;
    var response = await http.post(
      Uri.parse('$localURL/saveLeadTransaction'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'leadInfo': leadNoController.text,
          'personName': customerNameController.text,
          'personContact': phoneNumberController.text,
          'todoType': followUpModeController.text,
          'todoDescription': followUpDescriptionController.text,
          'meetDate': startTimeController.text,
          'executionDate': endTimeController.text,
          'followupDate': '${nextFollowUpDateController.text}r',
          'customerDOB': customerDOBController.text,
          'remarks': remarksController.text,
          'salesPerson': employIDD,
          'stepNo': leadStatusController.text,
          'lattitute': lat,
          'longitute': long,
          'userID': employIDD,
          'cancelReason': cancelReasonController.text,
          'lostToWhom': lostToWhomController.text,
          'leadProspectType': leadProspectTypeController.text,
          'tdModelName': modelNameController.text,
          'tdRequestedTime': requestedTestDriveDateTimeController.text,
          'tdApprovalStatus': testDriveApprovalStatus.text,
          'tdStatus': testdriveStatus.text,
          'isAutoFinance': isFinanceController.text
        },
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (Constants.selectedSearhed)
            ? Column(
                children: [
                  textShowFieldWidget('Lead No', leadNoController.text),
                  textShowFieldWidget(
                      'Customer Name', customerNameController.text),
                  DatePickerWidget('Customer DOB', customerDOBController),
                  DropDownWidget(
                    'What is the Mode of Follow-Up* :',
                    'Mode of Follow-Up* :',
                    followUpModeList,
                    followUpModeController,
                  ),
                  textTypeFieldWidget('Follow-Up Description',
                      followUpDescriptionController, false),
                  TimePickerWidget('Start Time*', '', startTimeController),
                  TimePickerWidget('End Time', '', endTimeController),
                  DatePickerWidget(
                      'Next Follow-Up Date*', nextFollowUpDateController),
                  textTypeFieldWidget('Remarks', remarksController, false),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      // padding: const EdgeInsets.only(left: -10.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 15),
                            child: Text(
                              'Inquiry Step Type* :',
                              style: //GoogleFonts.mcLaren
                                  TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            padding: const EdgeInsets.only(
                                top: 0, left: 15, right: 20),
                            value: leadStatusController.text,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 18,
                            elevation: 0,
                            style: //GoogleFonts.mcLaren
                                TextStyle(color: Colors.blue),
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              leadStatusController.text = value!;
                              leadProspectTypeController.text =
                                  leadProspectTypeList[leadStatusList
                                      .indexOf(leadStatusController.text)];
                              setState(() {
                                // leadStatusController.text = value!;
                                // leadProspectTypeController.text =
                                //     leadProspectTypeList[leadStatusList
                                //         .indexOf(leadStatusController.text)];
                              });
                            },
                            items: leadStatusList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(
                                          color: Colors.black,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (leadStatusController.text == 'CANCEL')
                      ? Column(
                          children: [
                            DropDownWidget(
                              'What was the cancel Reason?*',
                              'Cancel Reason*',
                              cancelReasonList,
                              cancelReasonController,
                            ),
                            (cancelReasonController.text ==
                                        'Lost to Competitor' ||
                                    cancelReasonController.text ==
                                        'Better Offer from Competitor')
                                ? textTypeFieldWidget(
                                    'Lost To Whom', lostToWhomController, false)
                                : Container()
                          ],
                        )
                      : Container(),
                  (leadStatusController.text == 'TEST-DRIVE')
                      ? Column(
                          children: [
                            DropDownWidget(
                              'Which Model:',
                              'Model Name',
                              modelList,
                              modelNameControllerMid,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5, bottom: 5),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (modelNameControllerMid
                                            .text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Select a model name..',
                                                textAlign: TextAlign.center,
                                                style: //GoogleFonts.mcLaren
                                                    TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          );
                                        } else {
                                          if (modelNameController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              modelNameController.text =
                                                  '${modelNameController.text} , ${modelNameControllerMid.text}';
                                              modelNameControllerMid.text = '';
                                            });
                                          } else {
                                            setState(() {
                                              modelNameController.text =
                                                  modelNameControllerMid.text;
                                              modelNameControllerMid.text = '';
                                            });
                                          }
                                        }
                                      },
                                      child: SizedBox(
                                        height: 40.0,
                                        width: 60.0,
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          //shadowColor: Colors.lightBlueAccent,
                                          color: Colors.blue[800],
                                          elevation: 7.0,
                                          child: Center(
                                            child: Text(
                                              "Add Model",
                                              textAlign: TextAlign.center,
                                              style: //GoogleFonts.mcLaren
                                                  TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50.0,
                                ),
                                Column(
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            modelNameController.text = '';
                                            modelNameControllerMid.text = '';
                                          });
                                        },
                                        child: SizedBox(
                                          height: 40.0,
                                          width: 60.0,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            //shadowColor: Colors.lightBlueAccent,
                                            color: Colors.blue[800],
                                            elevation: 7.0,
                                            child: Center(
                                              child: Text(
                                                "Cancel All\nModel",
                                                textAlign: TextAlign.center,
                                                style: //GoogleFonts.mcLaren
                                                    TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            textShowFieldWidget(
                                'Model Name*', modelNameController.text),
                            DatePickerWidget('Requested Test-Drive Date',
                                requestedTestDriveDateController),
                            TimePickerWidget(
                                'Requested Test-Drive Time*',
                                requestedTestDriveDateController.text,
                                requestedTestDriveTimeController),
                            DropDownWidget(
                              'Auto-Finance?*',
                              'Finance*',
                              isFinanceList,
                              isFinanceController,
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        print('sami');
                        final DateTime dateTimeNow = DateTime.now();
                        final dateTimeCreatedAt =
                            DateTime.parse(nextFollowUpDateController.text);
                        final differenceInDays =
                            dateTimeCreatedAt.difference(dateTimeNow).inDays;

                        leadProspectTypeController.text = leadProspectTypeList[
                            leadStatusList.indexOf(leadStatusController.text)];
                        print(leadProspectTypeController.text);

                        //test drive data update

                        if (leadStatusController.text != 'TEST-DRIVE') {
                          modelNameController.text = '';
                          requestedTestDriveDateController.text = '';
                          requestedTestDriveTimeController.text = '';
                          isFinanceController.text = '';
                          testDriveApprovalStatus.text = '';
                          testdriveStatus.text = '';
                          requestedTestDriveDateTimeController.text = '';
                        } else {
                          testDriveApprovalStatus.text = 'OPEN';
                          requestedTestDriveDateTimeController.text =
                              '${requestedTestDriveDateController.text} ${requestedTestDriveTimeController.text.split(' ')[1]}';
                          testdriveStatus.text = 'PENDING';
                          if (leadStatusController.text == 'TEST-DRIVE' &&
                              modelNameController.text == '' &&
                              isFinanceController.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Add Missing Fields!!',
                                  textAlign: TextAlign.center,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        }
                        if (leadStatusController.text != 'INVOICED' &&
                            leadStatusController.text != 'BOOKED' &&
                            leadStatusController.text != 'LOST' &&
                            leadStatusController.text != 'CANCEL') {
                          if (differenceInDays < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Previous Date Can't Be\nNext Follow-Up Date",
                                  textAlign: TextAlign.center,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else if (differenceInDays > 30) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Next Follow-Up Date Can't\nBe More Than One Month",
                                  textAlign: TextAlign.center,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            if (followUpModeController.text.isEmpty &&
                                startTimeController.text.isEmpty &&
                                leadStatusController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Add Missing Fields!!',
                                    textAlign: TextAlign.center,
                                    style: //GoogleFonts.mcLaren
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } else {
                              if (isPressed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Working on it..',
                                      textAlign: TextAlign.center,
                                      style: //GoogleFonts.mcLaren
                                          TextStyle(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Saving..',
                                      textAlign: TextAlign.center,
                                      style: //GoogleFonts.mcLaren
                                          TextStyle(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                isPressed = true;
                                var response = await saveNewLeadTransaction();
                                //print(json.encode(newLeadTransactionSend));
                                if (response.toLowerCase().trim() ==
                                    'success') {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/landingPage');
                                } else {
                                  setState(
                                    () {
                                      isPressed = false;
                                    },
                                  );
                                  print(response);
                                }
                              }
                            }
                          }
                        } else {
                          if (isPressed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Working on it..',
                                  textAlign: TextAlign.center,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Saving..',
                                  textAlign: TextAlign.center,
                                  style: //GoogleFonts.mcLaren
                                      TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            isPressed = true;
                            var response = await saveNewLeadTransaction();
                            //print(json.encode(newLeadTransactionSend));
                            if (response.toLowerCase().trim() == 'success') {
                              Navigator.of(context)
                                  .pushReplacementNamed('/landingPage');
                            } else {
                              setState(
                                () {
                                  isPressed = false;
                                },
                              );
                              print(response);
                            }
                          }
                        }
                      },
                      child: SizedBox(
                        height: 40.0,
                        width: 150.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              "Save",
                              style: //GoogleFonts.mcLaren
                                  TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                children: [
                  numberTypeFieldWidget('Lead No', leadNoController, false),
                  Text(
                    'OR',
                    style: //GoogleFonts.mcLaren
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                  ),
                  textTypeFieldWidget(
                      'Customer Name', customerNameController, false),
                  Text(
                    'OR',
                    style: //GoogleFonts.mcLaren
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                  ),
                  textTypeFieldWidget(
                      'Company Name', companyNameController, false),
                  Text(
                    'OR',
                    style: //GoogleFonts.mcLaren
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                  ),
                  numberTypeFieldWidget(
                      'Phone Number', phoneNumberController, false),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (phoneNumberController.text.isEmpty &&
                            leadNoController.text.isEmpty &&
                            customerNameController.text.isEmpty &&
                            companyNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fill any one field and search..',
                                textAlign: TextAlign.center,
                                style: //GoogleFonts.mcLaren
                                    TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: PopUpWidget(
                                leadNoController.text,
                                customerNameController.text,
                                phoneNumberController.text,
                                companyNameController.text, 'FALSE',
                                // callBackFunction: refresh(),
                              ),
                            ),
                          );
                          await refresh();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        height: 65.0,
                        width: 90.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              "Search Lead",
                              textAlign: TextAlign.center,
                              style: //GoogleFonts.mcLaren
                                  TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
      ],
    );
  }
}
