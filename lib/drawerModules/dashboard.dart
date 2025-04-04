import 'dart:convert';

import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DashBoardModule extends StatefulWidget {
  const DashBoardModule({Key? key}) : super(key: key);

  @override
  State<DashBoardModule> createState() => _DashBoardModuleState();
}

class _DashBoardModuleState extends State<DashBoardModule> {
  @override
  initState() {
    super.initState();
    getFollowUpData();
    getSummary();
  }

  int rowCount = 0;
  int totalLead = 0;
  int totalActiveLead = 0;
  int jsonCount = 0;
  int totalPendingLead = 0;
  bool isLoading = false;
  bool gotData = false;
  List<dynamic> stepNameList = [];
  List<dynamic> stepNameValueList = [];

  getFollowUpData() async {
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String searchDate = formatter.format(now);

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getFollowUpInfo'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getFollowUpInfo'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
          'searchDate': searchDate,
          'allSearch': 'FALSE'
        }));
    setState(() {
      var statusValue = jsonDecode(response.body)['leadList'];
      totalPendingLead = statusValue.length;
    });
  }

  getSummary() async {
    setState(() {});

    String localURL = Constants.globalURL;
    String employID = await getLocalEmployeeID();

    var getSummaryResponse = await http.post(Uri.parse('$localURL/getSummary'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': employID,
        }));
    var dataJSON = json.decode(getSummaryResponse.body);
    jsonCount = dataJSON.length;
    rowCount = (jsonCount / 2).round();
    for (int i = 0; i < jsonCount; i++) {
      stepNameList.add(dataJSON[i][0].toString());
      stepNameValueList.add(dataJSON[i][1].toString());
      totalLead += int.parse(dataJSON[i][1].toString());
      if (dataJSON[i][0].toString() != 'LOST') {
        if (dataJSON[i][0].toString() != 'INVOICED') {
          if (dataJSON[i][0].toString() != 'CANCEL') {
            if (dataJSON[i][0].toString() != 'INVALID') {
              totalActiveLead += int.parse(dataJSON[i][1].toString());
            }
          }
        }
      }
    }
    setState(() {
      if (getSummaryResponse.statusCode == 200) {
        isLoading = true;
      } else {
        throw Exception('Failed to load album');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (stepNameList.isNotEmpty)
        ? SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  (Constants.employeeId.contains(Constants.agentInitial))
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              rowField(
                                  'TOTAL LEAD', totalLead.toString(), 'TOTAL'),
                            ])
                      : Column(
                          children: <Widget>[
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  rowField('TOTAL LEAD', totalLead.toString(),
                                      'TOTAL'),
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  rowField(
                                      'TOTAL ACTIVE LEAD',
                                      totalActiveLead.toString(),
                                      'TOTAL ACTIVE'),
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  rowField(
                                      'TOTAL PENDING LEAD',
                                      totalPendingLead.toString(),
                                      'TOTAL ACTIVE'),
                                ]),
                            Column(
                              children: <Widget>[
                                ListView.builder(
                                    itemCount: rowCount,
                                    primary: false,
                                    //scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            rowField(
                                                'TOTAL ${stepNameList[index * 2]}',
                                                stepNameValueList[index * 2]
                                                    .toString(),
                                                stepNameList[index * 2]),
                                            ((index * 2) + 1 < jsonCount)
                                                ? rowField(
                                                    'TOTAL ${stepNameList[(index * 2) + 1]}',
                                                    stepNameValueList[
                                                            (index * 2) + 1]
                                                        .toString(),
                                                    stepNameList[
                                                        (index * 2) + 1])
                                                : Expanded(
                                                    flex: 1, child: Container())
                                          ]);
                                    })
                              ],
                            ),
                          ],
                        ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(
                        top: 50.0, right: 10.0, bottom: 10.0),
                    child: Text(
                      'Version ${Constants.version}\nDeveloped By Fair Group,\nIT Software Team',
                      textAlign: TextAlign.right,
                      style: //GoogleFonts.mcLaren
                          TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          )
        : const Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                CircularProgressIndicator(),
              ],
            ),
          );
  }

  Widget rowField(String rowName, String rowValue, String rowArguments) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
        child: SizedBox(
          height: 60.0,
          //width: MediaQuery.of(context).size.width,
          child: Material(
            borderRadius: BorderRadius.circular(25.0),
            //borderRadius: BorderRadius.(20.0),
            shadowColor: const Color.fromARGB(255, 65, 133, 250),
            color: Colors.white,
            elevation: 7.0,
            child: Center(
              child: Text(
                '$rowName\n$rowValue',
                style: //GoogleFonts.mcLaren
                    TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
