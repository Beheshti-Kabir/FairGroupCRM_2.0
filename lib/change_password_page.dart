import 'dart:convert';

import 'package:crm_app/main.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _changePassword createState() {
    return _changePassword();
  }
}

class _changePassword extends State<ChangePasswordPage> {
  //@override
  final _employID = TextEditingController();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _reNewPassword = TextEditingController();

  bool _employIDValidate = false;
  bool _oldPasswordValidate = false;
  bool _newPasswordValidate = false;
  bool _reNewPasswordValidate = false;

  bool isLoad = true;

  String employID = '';
  String oldPassword = '';
  String newPassword = '';
  String reNewPassword = '';

  formValidator() {
    String employIDVal = _employID.toString();
    //String meetDate = _meetDateController.text;
    String oldPasswordVal = _oldPassword.toString();
    String newPasswordVal = _newPassword.toString();
    String reNewpasswordVal = _reNewPassword.toString();
    setState(() {
      if (employIDVal.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      if (oldPasswordVal.isEmpty) {
        _oldPasswordValidate = true;
      } else {
        _oldPasswordValidate = false;
      }
      if (newPasswordVal.isEmpty) {
        _newPasswordValidate = true;
      } else {
        _newPasswordValidate = false;
      }
      if (reNewpasswordVal.isEmpty) {
        _reNewPasswordValidate = true;
      } else {
        _reNewPasswordValidate = false;
      }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_employIDValidate &&
        !_oldPasswordValidate &&
        !_newPasswordValidate &&
        !_reNewPasswordValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/changePwd'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'username': employID,
          'oldPassword': oldPassword,
          'newPassword': newPassword
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['result'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'EmployID & Password Don\'t Match';
      } else {
        return json.decode(response.body)['result'];
      }
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Column(children: <Widget>[
        textTypeFieldWidget('Employee ID*', _employID, _employIDValidate),
        textTypeFieldWidget(
            'Old Password*', _oldPassword, _oldPasswordValidate),
        textTypeFieldWidget(
            'New Password*', _newPassword, _newPasswordValidate),
        textTypeFieldWidget(
            'Re-Type New Password*', _reNewPassword, _reNewPasswordValidate),

        const SizedBox(height: 15.0),
        // save
        Container(
          child: Center(
            child: GestureDetector(
              onTap: () async {
                if (isLoad) {
                  bool isValid = formValidator();
                  if (isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Saving Change..',
                          textAlign: TextAlign.center,
                          style:
                              //GoogleFonts.mcLaren
                              TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );

                    setState(() {
                      isLoad = false;
                    });

                    if (_newPassword.text != _reNewPassword.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Typed Password Don't Match!!",
                            textAlign: TextAlign.center,
                            style: //GoogleFonts.mcLaren
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );

                      setState(
                        () {
                          isLoad = true;
                        },
                      );
                    } else {
                      employID = _employID.text;
                      oldPassword = _oldPassword.text;
                      newPassword = _newPassword.text;
                      reNewPassword = _reNewPassword.text;

                      var response = await createAlbum();

                      if (response.toLowerCase().trim() == 'success') {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                            (Route<dynamic> route) => false);
                      } else {
                        setState(
                          () {
                            isLoad = true;
                          },
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Server or internet issue!!",
                              textAlign: TextAlign.center,
                              style: //GoogleFonts.mcLaren
                                  TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }

                      print('MyResponse=>$response');
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
                  child: const Center(
                    child: Text(
                      "Save Change",
                      style: //GoogleFonts.mcLaren
                          TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
