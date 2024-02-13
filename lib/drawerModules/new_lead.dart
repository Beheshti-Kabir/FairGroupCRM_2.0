import 'dart:convert';
import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewLeadModule extends StatefulWidget {
  const NewLeadModule({Key? key}) : super(key: key);

  @override
  State<NewLeadModule> createState() => _NewLeadModuleState();
}

class _NewLeadModuleState extends State<NewLeadModule> {
  final phoneNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final customerNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final customerDOBController = TextEditingController();
  final leadCategoryController = TextEditingController();
  final professionController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final remarksController = TextEditingController();
  final leadSourceController = TextEditingController();
  final fincanceController = TextEditingController();
  final salesPersionController = TextEditingController();
  final nextFollowUpDateController = TextEditingController();
  final bsoController = TextEditingController();
  final coppiedFromController = TextEditingController();

  bool phoneNumberValidator = false;
  bool companyNameValidator = false;
  bool customerNameValidator = false;
  bool emailValidator = false;
  bool addressValidator = false;
  bool remarksValidator = false;
  bool isSaved = false;

  List leadCategoryList = ['', 'B2B', 'HP', 'CASH', 'GRT'];
  List financeList = ['', 'YES', 'NO'];
  List professionList = [''];
  List paymentMethodList = [''];
  List salesPersonList = [''];
  List leadSourceList = [''];

  @override
  void initState() {
    super.initState();
    Constants.selectedSearhed = false;
    prepareData();
  }

  prepareData() async {
    // [[leadStatusList],[leadSourceList],[salesPersonList],[paymentMethodList],[professionList]]

    bsoController.text = await getLocalEmployeeSBU();
    var data = await getData();
    setState(() {
      professionList = data[4];
      paymentMethodList = data[3];
      salesPersonList = data[2];
      leadSourceList = data[1];
    });
  }

  refresh() async {
    customerNameController.text = Constants.selectedCustomerName;
    companyNameController.text = Constants.selectedCompanyName;
    coppiedFromController.text = Constants.selectedcoppiedFrom;
    if (!Constants.isDataAvailable) {
      customerNameController.text = '';
      companyNameController.text = '';
      Constants.selectedSearhed = true;
    }
    setState(() {});
  }

  formValidator() {
    setState(() {
      if (phoneNumberController.text.isEmpty) {
        phoneNumberValidator = true;
      } else {
        phoneNumberValidator = false;
      }
      if (customerNameController.text.isEmpty) {
        customerNameValidator = true;
      } else {
        customerNameValidator = false;
      }

      if (companyNameController.text.isEmpty) {
        companyNameValidator = true;
      } else {
        companyNameValidator = false;
      }
      if (addressController.text.isEmpty) {
        addressValidator = true;
      } else {
        addressValidator = false;
      }
      if (emailController.text.isEmpty) {
        emailValidator = true;
      } else {
        emailValidator = false;
      }
      if (remarksController.text.isEmpty) {
        remarksValidator = true;
      } else {
        remarksValidator = false;
      }
    });
    if (!phoneNumberValidator &&
        !customerNameValidator &&
        !companyNameValidator &&
        !addressValidator &&
        !emailValidator &&
        !remarksValidator) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> saveLeadInfo() async {
    String localURL = Constants.globalURL;
    String userID = await getLocalEmployeeID();

    var response = await http.post(Uri.parse('$localURL/saveLeadInfoNew'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'customerName': customerNameController.text,
          'customerContact': phoneNumberController.text,
          'customerAddress': addressController.text,
          'customerEmail': emailController.text,
          'customerDOB': customerDOBController.text,
          'companyName': companyNameController.text,
          'remark': remarksController.text,
          'profession': professionController.text,
          'salesPerson': salesPersionController.text.split(' ')[0],
          'leadSource': leadSourceController.text,
          'paymentMethod': paymentMethodController.text,
          'isAutoFinance': fincanceController.text,
          'leadCategory': leadCategoryController.text,
          'userID': userID,
          'nextFollowUpDate': nextFollowUpDateController.text,
          'bsoType': bsoController.text,
          'leadProspectType': 'IN-PROGRESS',
          'copiedFrom': coppiedFromController.text,
        }));

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  clearData() {
    phoneNumberController.clear();
    companyNameController.clear();
    customerNameController.clear();
    emailController.clear();
    addressController.clear();
    customerDOBController.clear();
    leadCategoryController.clear();
    professionController.clear();
    paymentMethodController.clear();
    remarksController.clear();
    leadSourceController.clear();
    fincanceController.clear();
    salesPersionController.clear();
    nextFollowUpDateController.clear();
    bsoController.clear();
    coppiedFromController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (!Constants.selectedSearhed)
            ? Column(
                children: [
                  textTypeFieldWidget(
                      'Company Name', companyNameController, false),
                  const Text(
                    'OR',
                    style: TextStyle(
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
                            companyNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fill any one field and search..',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: PopUpWidget(
                                '', '',
                                phoneNumberController.text,
                                companyNameController.text, 'TRUE',
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
                          child: const Center(
                            child: Text(
                              "Search Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    textTypeFieldWidget('Customer Name*',
                        customerNameController, customerNameValidator),
                    numberTypeFieldWidget('Contact Number*',
                        phoneNumberController, phoneNumberValidator),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Please make sure the number is 11 digit for Bangladeshi Customers.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    textTypeFieldWidget('Company Name*', companyNameController,
                        companyNameValidator),
                    textTypeFieldWidget(
                        'Email Address*', emailController, emailValidator),
                    textTypeFieldWidget(
                        'Address*', addressController, addressValidator),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Please don't use any special carecter like * & # in Address field.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    DatePickerWidget(
                        'Customer Date of Birth ', customerDOBController),
                    DropDownWidget('Profession* :', 'Profession :',
                        professionList, professionController),
                    DropDownWidget('Lead Category :', 'Lead Category :',
                        leadCategoryList, leadCategoryController),
                    DropDownWidget('Payment Method :', 'Payment Method :',
                        paymentMethodList, paymentMethodController),
                    DropDownWidget('Lead Source* :', 'Lead Source :',
                        leadSourceList, leadSourceController),
                    DropDownWidget('Finance* :', 'Finance :', financeList,
                        fincanceController),
                    DatePickerWidget(
                        'Next Follow-up Date* ', nextFollowUpDateController),
                    textTypeFieldWidget(
                        'Remarks*', remarksController, remarksValidator),
                    DropDownWidget('Sales Person* :', 'Sales Person* :',
                        salesPersonList, salesPersionController),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          bool isValid = formValidator();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Saving..',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          if (isValid &&
                              !isSaved &&
                              professionController.text.isNotEmpty &&
                              salesPersionController.text.isNotEmpty &&
                              leadSourceController.text.isNotEmpty &&
                              remarksController.text.isNotEmpty &&
                              fincanceController.text.isNotEmpty &&
                              nextFollowUpDateController.text.isNotEmpty) {
                            setState(() => isSaved = true);
                            var response = await saveLeadInfo();

                            if (response.toLowerCase().trim() == 'success') {
                              await clearData();
                              if (Constants.employeeId
                                  .contains(Constants.agentInitial)) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/agentLandingPage');
                              } else {
                                Navigator.of(context)
                                    .pushReplacementNamed('/landingPage');
                              }
                            } else {
                              setState(() => isSaved = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Server Issue!!',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Some mandatory fields may be missing!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          alignment: Alignment.center,
                          height: 85.0,
                          width: 90.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.lightBlueAccent,
                            color: Colors.blue[800],
                            elevation: 7.0,
                            child: const Center(
                              child: Text(
                                "Save Lead",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}
