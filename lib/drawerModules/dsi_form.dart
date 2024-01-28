import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DSIFormModule extends StatefulWidget {
  const DSIFormModule({Key? key}) : super(key: key);

  @override
  State<DSIFormModule> createState() => _DSIFormModuleState();
}

class _DSIFormModuleState extends State<DSIFormModule> {
  final jobCardMasterIdController = TextEditingController();
  final orderNoController = TextEditingController();
  final regNoController = TextEditingController();
  final carModelController = TextEditingController();
  final saNameController = TextEditingController();
  final customerNameController = TextEditingController();

  final answer1 = TextEditingController();
  final answer2 = TextEditingController();
  final answer3 = TextEditingController();
  final answer4 = TextEditingController();
  final answer5 = TextEditingController();
  final answer6 = TextEditingController();
  final answer7 = TextEditingController();
  final answer8 = TextEditingController();
  final answer9 = TextEditingController();
  final answer10 = TextEditingController();
  final answer3Remarks = TextEditingController();
  final answer4Remarks = TextEditingController();
  final answer5Remarks = TextEditingController();
  final answer6Remarks = TextEditingController();
  final feedbackController = TextEditingController();
  final formTypeController = TextEditingController();

  bool orderNoValidator = false;
  bool regNoValidator = false;
  bool carModelValidator = false;
  bool saNameValidator = false;
  bool answer10Validator = false;
  bool feedbackValidator = false;
  bool customerNameValidator = false;
  bool isSearched = false;

  List<dynamic> formTypeList = ['', 'DSI', 'PSF'];

  List<dynamic> ratingList = [
    '10',
    '9',
    '8',
    '7',
    '6',
    '5',
    '4',
    '3',
    '2',
    '1',
    ''
  ];

  bool formValidator() {
    setState(() {
      if (orderNoController.text.isEmpty) {
        orderNoValidator = true;
      } else {
        orderNoValidator = false;
      }

      if (customerNameController.text.isEmpty) {
        customerNameValidator = true;
      } else {
        customerNameValidator = false;
      }

      if (regNoController.text.isEmpty) {
        regNoValidator = true;
      } else {
        regNoValidator = false;
      }
      if (carModelController.text.isEmpty) {
        carModelValidator = true;
      } else {
        carModelValidator = false;
      }

      if (saNameController.text.isEmpty) {
        saNameValidator = true;
      } else {
        saNameValidator = false;
      }
    });
    if (!orderNoValidator &&
        !customerNameValidator &&
        !regNoValidator &&
        !carModelValidator &&
        !saNameValidator &&
        answer1.text.isNotEmpty &&
        answer2.text.isNotEmpty &&
        answer3.text.isNotEmpty &&
        answer4.text.isNotEmpty &&
        answer5.text.isNotEmpty &&
        answer6.text.isNotEmpty &&
        answer7.text.isNotEmpty &&
        answer8.text.isNotEmpty &&
        answer9.text.isNotEmpty &&
        answer10.text.isNotEmpty &&
        formTypeController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> dsiFormSave() async {
    String localURL = Constants.dsiGlobalURL;
    var response = await http.post(
      Uri.parse('$localURL/saveDsiForm'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'repairOrderNo': orderNoController.text,
          'customerName': customerNameController.text,
          'registrationNo': regNoController.text,
          'carModel': carModelController.text,
          'saName': saNameController.text,
          'answer1': answer1.text,
          'answer2': answer2.text,
          'answer3': answer3.text,
          'answer3Remarks': answer3Remarks.text,
          'answer4': answer4.text,
          'answer4Remarks': answer4Remarks.text,
          'answer5': answer5.text,
          'answer5Remarks': answer5Remarks.text,
          'answer6': answer6.text,
          'answer6Remarks': answer6Remarks.text,
          'answer7': answer7.text,
          'answer8': answer8.text,
          'answer9': answer9.text,
          'answer10': answer10.text,
          'feedBack': feedbackController.text,
          'createdBy': Constants.employeeId,
          'formType': formTypeController.text,
        },
      ),
    );

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  roSearch() async {
    String localURL = Constants.dsiGlobalURL;
    var response = await http.post(
      Uri.parse('$localURL/getInfoByJobNo'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'roNo': orderNoController.text,
        },
      ),
    );

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      if (json.decode(response.body)['jobCard'].length > 0) {
        setState(() {
          jobCardMasterIdController.text =
              json.decode(response.body)['jobCard'][0]['id'].toString();
          orderNoController.text =
              json.decode(response.body)['jobCard'][0]['jobNo'].toString();
          customerNameController.text = json
              .decode(response.body)['jobCard'][0]['customerName']
              .toString();
          regNoController.text = json
              .decode(response.body)['jobCard'][0]['registrationNo']
              .toString();
          carModelController.text =
              json.decode(response.body)['jobCard'][0]['modelNo'].toString();
          saNameController.text = json
              .decode(response.body)['jobCard'][0]['advisorName']
              .toString();
          isSearched = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No Data Found!!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Server Issue!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          (!isSearched)
              ? Column(
                  children: [
                    textTypeFieldWidget('Repair Order No*', orderNoController,
                        orderNoValidator),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              if (orderNoController.text.isNotEmpty) {
                                await roSearch();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please provide more than 5 character!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 30.0,
                              width: 100.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.blueAccent,
                                color: Colors.blue[800],
                                elevation: 7.0,
                                child: const Center(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    textShowFieldWidget(
                        'Repair Order No', orderNoController.text),
                    textTypeFieldWidget('Customer Name*',
                        customerNameController, customerNameValidator),
                    textTypeFieldWidget(
                        'Registration No*', regNoController, regNoValidator),
                    textTypeFieldWidget(
                        'Car Model*', carModelController, carModelValidator),
                    textTypeFieldWidget(
                        'SA Name*', saNameController, saNameValidator),
                    DropDownWidget('What type of form is this?* ',
                        'Form Type :', formTypeList, formTypeController),
                    DropDownWidget(
                      '1. Were you attended promptly when you came to the workshop ?',
                      '1. Were you attended promptly when you came to the workshop ?',
                      const [
                        '',
                        'YES',
                        'NO',
                      ],
                      answer1,
                    ),
                    DropDownWidget(
                      '2. Was your car ready at the date and time promised by Service Advisor ?',
                      '2. Was your car ready at the date and time promised by Service Advisor ?',
                      const ['', 'YES', 'NO'],
                      answer2,
                    ),
                    DropDownWidget(
                      '3. How do you rate the Overall Cleanliness of the Workshop ?',
                      '3. Workshop Clinliness Rating',
                      ratingList,
                      answer3,
                    ),
                    textTypeFieldWidget(
                        'If < 8 in third question which area needs improvement',
                        answer3Remarks,
                        false),
                    DropDownWidget(
                      '4. Was the Waiting Area Comfortable ?',
                      '4. Waiting Room Rating :',
                      ratingList,
                      answer4,
                    ),
                    textTypeFieldWidget(
                        'If < 8 in fourth question which area needs improvement',
                        answer4Remarks,
                        false),
                    DropDownWidget(
                      '5. How convenient was it to park you vehicle when you came to workshop ?',
                      '5. Workshop Parking Rating :',
                      ratingList,
                      answer5,
                    ),
                    textTypeFieldWidget(
                        'If < 8 in fifth question which area needs improvement',
                        answer5Remarks,
                        false),
                    DropDownWidget(
                      '6. How do you rate the quality of the washing and cleaning of you car ?',
                      '6. Car Washing & Cleaning Rating :',
                      ratingList,
                      answer6,
                    ),
                    textTypeFieldWidget(
                        'If < 8 in sixth question which area needs improvement',
                        answer6Remarks,
                        false),
                    DropDownWidget(
                      '7. Are the charges of Service & Repair :',
                      '7. Are the charges of Service & Repair :',
                      const [
                        '',
                        'AS PER ESTIMATE PROVIDED',
                        'MORE THAN ESTIMATE PROVIDED',
                        'NO ESTIMATE PROVIDED'
                      ],
                      answer7,
                    ),
                    DropDownWidget(
                      '8. How do you rate explanation given by Service Advisor for work done on you car ?',
                      '8. Service Advisor Explanation Rating :',
                      ratingList,
                      answer8,
                    ),
                    DropDownWidget(
                      '9. How do you rate your overall interaction & experience with the workshop during this visit ?',
                      '9. Interaction & Experience Rating :',
                      ratingList,
                      answer9,
                    ),
                    textTypeFieldWidget('10. Refer names of friends/relatives',
                        answer10, answer10Validator),
                    textTypeFieldWidget('Suggestion / Feedback (if any)',
                        feedbackController, feedbackValidator),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              bool isValid = formValidator();
                              if (isValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Saving..',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                var respon = await dsiFormSave();
                                if (respon.toLowerCase().trim() == 'success') {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/landingPage');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Server Issue!!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Mandatory Field Data Missing!!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 30.0,
                              width: 100.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.blueAccent,
                                color: Colors.blue[800],
                                elevation: 7.0,
                                child: const Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
        ]);
  }
}
