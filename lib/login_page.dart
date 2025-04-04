import 'dart:convert';

import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:login_prac/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final employIDController = TextEditingController();
  final passwordController = TextEditingController();
  bool employIDValidate = false;
  bool passwordValidate = false;
  String version = Constants.version;
  late String employeeName;
  late String employeeContact;
  late String sbu;
  late String employeeEmail;

  bool formValidator() {
    String employID = employIDController.text;
    String password = passwordController.text;

    setState(() {
      if (employID.isEmpty) {
        employIDValidate = true;
      } else {
        employIDValidate = false;
      }
      if (password.isEmpty) {
        passwordValidate = true;
      } else {
        passwordValidate = false;
      }
    });
    if (!employIDValidate && !passwordValidate) {
      return true;
    } else {
      return false;
    }
  }

  setData() async {
    storeLocalSetLogInStatus(Constants.logInStatusKey, 'success');
    storeLocalSetEmployeeID(Constants.employeeIDKey, employIDController.text);
    storeLocalSetEmployeeName(Constants.employeeNameKey, employeeName);
    storeLocalSetEmployeeEmail(Constants.employeeEmailKey, employeeEmail);
    storeLocalSetEmployeeContact(Constants.employeeContactKey, employeeContact);
    storeLocalSetEmployeeSBU(Constants.employeeSBUKey, sbu);
    if (employIDController.text.contains(Constants.agentInitial)) {
      Navigator.of(context).pushReplacementNamed('/agentLandingPage');
    } else {
      Navigator.of(context).pushReplacementNamed('/landingPage');
    }
  }

  Future<String> logInRequest() async {
    var apiResponse = await http.post(
        Uri.parse('${Constants.globalURL}/apiLogin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'username': employIDController.text.trim(),
          'password': passwordController.text.trim(),
        }));
    var responseBodyStatus = json.decode(apiResponse.body)['result'];

    if (apiResponse.statusCode == 200) {
      if (responseBodyStatus.toString().toLowerCase().trim() == 'success') {
        employeeName = json.decode(apiResponse.body)['userName'].toString();
        employeeEmail = json.decode(apiResponse.body)['email'].toString();
        employeeContact = json.decode(apiResponse.body)['contactNo'].toString();
        switch (json.decode(apiResponse.body)['companyCode'].toString()) {
          case '1000':
            sbu = 'FDL';
            break;
          case '2000':
            sbu = 'FTL';
            break;
          case '8000':
            sbu = 'FEL';
            break;
        }
        await setData();
        Constants.employeeId = employIDController.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged In..',
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
              'Wrong Credentials!!',
              textAlign: TextAlign.center,
              style: //GoogleFonts.mcLaren
                  TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Network or Server Issue..',
            textAlign: TextAlign.center,
            style: //GoogleFonts.mcLaren
                TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return 'nothing';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: Text(
                        'Fair',
                        style: //GoogleFonts.mcLaren
                            TextStyle(
                                color: Colors.blue[800],
                                fontSize: 80,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                      child: Text(
                        'Group',
                        style: //GoogleFonts.mcLaren
                            TextStyle(
                                color: Colors.blue[800],
                                fontSize: 80,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 260.0, 0.0, 0.0),
                      child: Text(
                        'CRM',
                        style: //GoogleFonts.mcLaren
                            TextStyle(
                                color: Colors.red[400],
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100, left: 5.0, right: 5.0),
                child: textTypeFieldWidget(
                    'Employee ID*', employIDController, employIDValidate),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 5.0, right: 5.0, bottom: 35.0),
                child: textTypeFieldWidget(
                    'Password*', passwordController, passwordValidate),
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    bool isValid = formValidator();
                    isValid == true
                        ? ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Logging In..\nWait for a while please..',
                                textAlign: TextAlign.center,
                                style: //GoogleFonts.mcLaren
                                    TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Field Missing!!!!!',
                                textAlign: TextAlign.center,
                                style: //GoogleFonts.mcLaren
                                    TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );

                    if (isValid) {
                      await logInRequest();
                    }

                    //Navigator.of(context).pushNamed('/summery');
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
                          "Log In",
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
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Loading..',
                          textAlign: TextAlign.center,
                          style:
                              //GoogleFonts.mcLaren
                              TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    Navigator.pushNamed(context, '/changePasswordPage');
                  },
                  child: SizedBox(
                    height: 60.0,
                    //width: 170.0,
                    child: Material(
                      //borderRadius: BorderRadius.(20.0),
                      //shadowColor: Color.fromARGB(255, 65, 133, 250),
                      //color: Colors.white,

                      child: Center(
                        child: Text(
                          'Change Password',
                          style: //GoogleFonts.mcLaren
                              TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
