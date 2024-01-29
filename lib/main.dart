import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm_app/change_password_page.dart';
import 'package:crm_app/landing_page.dart';
import 'package:crm_app/landing_page_agent.dart';
import 'package:crm_app/login_page.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/logInPage': (BuildContext context) => const LoginPage(),
          '/changePasswordPage': (BuildContext context) =>
              const ChangePasswordPage(),
          '/landingPage': (BuildContext context) => const LandingPage(),
          '/agentLandingPage': (BuildContext context) =>
              const AgentLandingPage(),
        },
        title: 'CRM App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
        builder: (context, widget) {
          /// Always Constant font size though change system font size
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String route = '';
  late String error = '';
  late String web_version = '';
  String app_version = Constants.version;
  @override
  void initState() {
    super.initState();
    getVersion();
  }

  getVersion() async {
    Constants.employeeId = await getLocalEmployeeID();
    try {
      String localURL = Constants.globalURL;
      var response = await http.get(
        Uri.parse('$localURL/getAppVersion'),
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getLeadData'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );
      web_version = json.decode(response.body)['CRM_VERSION'];

      getRoutePath();
    } catch (e) {
      error = e.toString();
    }
    print("Type of error in calling version : $error");
    workDone();
  }

  getRoutePath() async {
    Constants.employeeId = await getLocalEmployeeID();

    print('main=${Constants.employeeId}');
    bool logInStatus = await getLocalLoginStatus();
    if (logInStatus) {
      if (Constants.employeeId.contains(Constants.agentInitial)) {
        route = '/agentLandingPage';
      } else {
        route = '/landingPage';
      }
    } else {
      route = '/logInPage';
    }
  }

  workDone() async {
    if (error != '') {
      Timer(
          const Duration(seconds: 2),
          () => QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                onConfirmBtnTap: () => exit(0),
                title: 'Oppss!!',
                text:
                    'Check your internet connection!!\nOR\nServer is down for upgradation..\nWait for 10 min please..\n\nContact Administrator\n(+8801777702090)',
              ));
    } else {
      if (web_version == app_version) {
        Timer(const Duration(seconds: 2),
            () => Navigator.of(context).pushReplacementNamed(route));
      } else {
        Timer(
            const Duration(seconds: 2),
            () => QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  onConfirmBtnTap: () => exit(0),
                  title: 'New Version!!',
                  text:
                      'You are running the CRM $app_version\nThe current CRM version is $web_version\n\nContact Administrator\n(+8801777702090)',
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/fairgroup_logo.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
