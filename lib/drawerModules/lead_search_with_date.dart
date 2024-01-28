import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';

class DateSearchModule extends StatefulWidget {
  const DateSearchModule({Key? key}) : super(key: key);

  @override
  State<DateSearchModule> createState() => _DateSearchModuleState();
}

class _DateSearchModuleState extends State<DateSearchModule> {
  bool isSearching = false;
  bool phoneNoValidate = false;
  bool leadNoValidate = false;
  List<dynamic> statusValue = [];
  List<dynamic> leadStatusList = [];
  List<dynamic> allList = [];

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final leadStatusController = TextEditingController();

  @override
  initState() {
    super.initState();
    getAPIData();
  }

  refresh() {}
  setLoadingScreen() async {
    setState(() {
      isSearching = true;
    });

    statusValue = await getLeadSearchData(
      '',
      '',
      '',
      leadStatusController.text,
      toDateController.text,
      fromDateController.text,
      'FALSE',
      '',
    );
    // getLeadSearchData(phoneNumber, companyName, leadNo, stepType, toDate, fromDate, allSearch)

    setState(() {
      if (statusValue.isEmpty) {
        isSearching = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'NO DATA IN THIS LEAD MODE...',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        toDateController.clear();
        fromDateController.clear();
        leadStatusController.clear();
      }
    });
  }

  getAPIData() async {
    allList = await getData();
    leadStatusList = allList[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DatePickerWidget('From Date*', fromDateController),
            DatePickerWidget('To Date*', toDateController),
            DropDownWidget('Select Lead Status ', 'Lead Status : ',
                leadStatusList, leadStatusController),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Searching..',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      (fromDateController.text.isNotEmpty &&
                                  toDateController.text.isNotEmpty) ||
                              leadStatusController.text.isNotEmpty
                          ? setLoadingScreen()
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Input Date Range or Lead Status!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
            isSearching == false
                ? Container()
                : statusValue.isNotEmpty
                    ? ListViewWidget(statusValue, false, false)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
          ],
        ),
      )
    ]);
  }
}
