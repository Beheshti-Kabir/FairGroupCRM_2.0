import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class TestDriveModule extends StatefulWidget {
  const TestDriveModule({Key? key}) : super(key: key);

  @override
  State<TestDriveModule> createState() => _TestDriveModuleState();
}

class _TestDriveModuleState extends State<TestDriveModule> {
  bool isSearching = false;
  bool phoneNoValidate = false;
  bool leadNoValidate = false;
  List<dynamic> statusValue = [];
  List<String> testDriveStatusList = ['', 'OPEN', 'APPROVED', 'DENIED'];

  final phoneNumberController = TextEditingController();
  final leadNoController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final testDriveStatusController = TextEditingController();
  freeRefresh() {}
  setLoadingScreen() async {
    setState(() {
      isSearching = true;
    });

    if (leadNoController.text.isNotEmpty) {
      toDateController.text = '';
      fromDateController.text = '';
      testDriveStatusController.text = '';
    } else {
      leadNoController.text = '';
    }
    statusValue = await getLeadSearchData(
        '',
        '',
        '',
        leadNoController.text,
        'TEST-DRIVE',
        toDateController.text,
        fromDateController.text,
        'FALSE',
        testDriveStatusController.text);

    // statusValue = await getLeadSearchData(phoneNumber, companyName, leadNo, stepType, toDate, fromDate, allSearch,)

    setState(() {
      if (statusValue.isEmpty) {
        isSearching = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'NO DATA IN THIS LEAD MODE...',
              textAlign: TextAlign.center,
              style: //GoogleFonts.mcLaren
                  TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        fromDateController.clear();
        toDateController.clear();
        testDriveStatusController.clear();
        leadNoController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              numberTypeFieldWidget(
                  'Lead No*', leadNoController, leadNoValidate),
              const Text(
                'OR',
                style: //GoogleFonts.mcLaren
                    TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
              ),
              DatePickerWidget('From Date*', fromDateController),
              DatePickerWidget('To Date*', toDateController),
              DropDownWidget(
                  'Test-Drive Approval Status :',
                  'Test-Drive Approval Status :',
                  testDriveStatusList,
                  testDriveStatusController),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        (leadNoController.text.isNotEmpty ||
                                (fromDateController.text.isNotEmpty &&
                                    toDateController.text.isNotEmpty &&
                                    testDriveStatusController.text.isNotEmpty))
                            ? setLoadingScreen()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Input mandatory fields to search!!',
                                    textAlign: TextAlign.center,
                                    style: //GoogleFonts.mcLaren
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
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
                              style: //GoogleFonts.mcLaren
                                  TextStyle(
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
              isSearching == false
                  ? Container()
                  : statusValue.isNotEmpty
                      ? ListViewWidget(statusValue, false, true)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            ],
          ),
        ),
      )
    ]);
  }
}
