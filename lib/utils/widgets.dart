import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget textTypeFieldWidget(
    String typeTitle, TextEditingController typeController, bool typeValidate) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlueAccent,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: typeController,
        maxLines: 10,
        minLines: 1,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: typeValidate ? 'Value Can\'t Be Empty' : null,
          labelText: '$typeTitle :',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]),
        ),
      ),
    ),
  );
}

Widget numberTypeFieldWidget(
    String typeTitle, TextEditingController typeController, bool typeValidate) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlueAccent,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: typeController,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        keyboardType: TextInputType.number,
        //  inputFormatters: [LengthLimitingTextInputFormatter(11)],
        decoration: InputDecoration(
          border: InputBorder.none,
          errorText: typeValidate ? 'Value Can\'t Be Empty' : null,
          labelText: '$typeTitle :',
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
      ),
    ),
  );
}

Widget textShowFieldWidget(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      alignment: Alignment.centerLeft,
      width: 1000,
      height: 60,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.lightBlueAccent,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: RichText(
        text: TextSpan(
            text: '$title : ',
            style: TextStyle(
                color: Colors.blue[700],
                fontSize: 16,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: value,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              )
            ]),
      ),
    ),
  );
}

TableRow tableRowWidget(String titleName, String value) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 1),
      child: Text(titleName, style: const TextStyle(fontSize: 18.0)),
    ),
    Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 1),
      child: Text(value, style: const TextStyle(fontSize: 18.0)),
    ),
  ]);
}

class ListViewWidget extends StatefulWidget {
  final List listValue;
  final bool tapAble;
  final bool isTestDrive;
  const ListViewWidget(this.listValue, this.tapAble, this.isTestDrive,
      {super.key});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  Future<String> changeTDApprovalStatus(String leadNo, String status) async {
    String localURL = Constants.globalURL;
    @override
    initState() {
      Constants.selectedSearhed = false;
      super.initState();
      Constants.selectedCompanyName = '';
      Constants.selectedCustomerName = '';
      Constants.selectedLeadNo = '';
      Constants.selectedPhoneNumber = '';
      Constants.selectedDOB = '';
      Constants.selectedcoppiedFrom = '';
    }

    var responsed = await http.post(Uri.parse('$localURL/approveLead'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'leadNo': leadNo,
          'approvalStatus': status,
        }));

    String con = jsonDecode(responsed.body)['result'].toString();

    if (con == 'Success') {
      return 'Done';
    } else {
      return 'Failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listValue.length,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 10.0, right: 4.0),
          child: GestureDetector(
            onTap: () {
              if (widget.tapAble) {
                Constants.selectedCompanyName =
                    widget.listValue[index]['companyName'].toString();
                Constants.selectedCustomerName =
                    widget.listValue[index]['customerName'].toString();
                Constants.selectedLeadNo =
                    widget.listValue[index]['leadNo'].toString();
                Constants.selectedPhoneNumber =
                    widget.listValue[index]['contactNo'].toString();
                Constants.selectedDOB =
                    widget.listValue[index]['dob'].toString();
                Constants.selectedcoppiedFrom =
                    widget.listValue[index]['createdBy'].toString();
                Constants.selectedSearhed = true;

                Navigator.of(context).pop();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: (!widget.isTestDrive)
                  ? Table(
                      //defaultColumnWidth: const FixedColumnWidth(180.0),
                      border: TableBorder.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2),

                      children: [
                        tableRowWidget('Lead No',
                            widget.listValue[index]['leadNo'].toString()),
                        tableRowWidget('Customer Name',
                            widget.listValue[index]['customerName'].toString()),
                        tableRowWidget('Customer Number',
                            widget.listValue[index]['contactNo'].toString()),
                        tableRowWidget('Customer Address',
                            widget.listValue[index]['address'].toString()),
                        tableRowWidget('Company name',
                            widget.listValue[index]['companyName'].toString()),
                        tableRowWidget('Lead Create Time',
                            "${widget.listValue[index]['leadCreateTime'].toString().split(" ")[0]}\n \n${widget.listValue[index]['leadCreateTime'].toString().split(" ")[1]}"),
                        tableRowWidget(
                            'Next Follow-up Date',
                            widget.listValue[index]['followupDate']
                                .toString()
                                .split("T")[0]),
                        tableRowWidget('Lead Type',
                            widget.listValue[index]['leadCategory'].toString()),
                        tableRowWidget(
                            'Lead Prospect Type',
                            widget.listValue[index]['leadProspectType']
                                .toString()),
                        tableRowWidget('Step Type',
                            widget.listValue[index]['stepType'].toString()),
                        tableRowWidget('Created By',
                            '${widget.listValue[index]['createdByName'].toString()} ( ${widget.listValue[index]['createdBy'].toString()} )'),
                        tableRowWidget(
                            'Products',
                            widget.listValue[index]['productName']
                                .toString()
                                .substring(
                                    1,
                                    widget.listValue[index]['productName']
                                            .toString()
                                            .length -
                                        1)),
                        tableRowWidget(
                            'Last Trsansaction Date',
                            widget.listValue[index]['lastTransactionDate']
                                .toString()
                                .split(" ")[0]),
                        tableRowWidget('Last Transaction Remarks',
                            widget.listValue[index]['remarks'].toString()),
                      ],
                    )
                  : Table(
                      //defaultColumnWidth: const FixedColumnWidth(180.0),
                      border: TableBorder.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 2),

                      children: [
                        tableRowWidget('Lead No',
                            widget.listValue[index]['leadNo'].toString()),
                        tableRowWidget('Customer Name',
                            widget.listValue[index]['customerName'].toString()),
                        tableRowWidget('Customer Number',
                            widget.listValue[index]['contactNo'].toString()),
                        tableRowWidget('Lead Create Time',
                            "${widget.listValue[index]['leadCreateTime'].toString().split(" ")[0]}\n \n${widget.listValue[index]['leadCreateTime'].toString().split(" ")[1]}"),
                        tableRowWidget('Model Name',
                            widget.listValue[index]['tdModelName'].toString()),
                        (widget.listValue[index]['tdApprovalStatus']
                                        .toString() ==
                                    'OPEN' &&
                                (Constants.employeeId == 'T00100' ||
                                    Constants.employeeId == 'M00129'))
                            ? TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Text('Change Approval Status',
                                      style: TextStyle(fontSize: 20.0)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          backgroundColor: Colors.white,
                                          elevation: 24,
                                          shadowColor: Colors.black,
                                          title: const Text(
                                            'Status Change',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 25),
                                          ),
                                          content: Text(
                                            'What status do you want for the Lead No: ${widget.listValue[index]['leadNo']} ?',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Saving...',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );

                                                var respon =
                                                    await changeTDApprovalStatus(
                                                        widget.listValue[index]
                                                                ['leadNo']
                                                            .toString(),
                                                        'APPROVED');

                                                if (respon.toString() ==
                                                    'Done') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Status Change to APPROVED..',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                  );

                                                  setState(() {
                                                    widget.listValue[index][
                                                            'tdApprovalStatus'] =
                                                        'APPROVED';
                                                  });

                                                  Navigator.of(context).pop();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'There might be some issue.\nPlease try again..',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Approved',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            CupertinoDialogAction(
                                              onPressed: () async {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Saving...',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                var respon =
                                                    await changeTDApprovalStatus(
                                                        widget.listValue[index]
                                                                ['leadNo']
                                                            .toString(),
                                                        'DENIED');

                                                if (respon == 'Done') {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Status Change to DENIED..',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                  );

                                                  setState(() {
                                                    widget.listValue[index][
                                                            'tdApprovalStatus'] =
                                                        'DENIED';
                                                  });

                                                  Navigator.of(context).pop();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'There might be some issue.\nPlease try again..',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Denied',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.lightBlue[100]),
                                    child: Text(
                                        widget.listValue[index]
                                                ['tdApprovalStatus']
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black)),
                                  ),
                                ),
                              ])
                            : tableRowWidget(
                                'Approval Status',
                                widget.listValue[index]['tdApprovalStatus']
                                    .toString()),
                        tableRowWidget('Requested Time',
                            "${widget.listValue[index]['tdRequestedTime'].toString().split(" ")[0]}\n \n${widget.listValue[index]['tdRequestedTime'].toString().split(" ")[1]}"),
                        tableRowWidget('Test-Drive Status',
                            widget.listValue[index]['tdStatus'].toString()),
                        tableRowWidget('Test-Drive Time',
                            widget.listValue[index]['tdTime'].toString()),
                        tableRowWidget(
                            'Auto Finance',
                            widget.listValue[index]['isAutoFinance']
                                .toString()),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 1),
                            child: Text('', style: TextStyle(fontSize: 18.0)),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: GestureDetector(
                                onTap: () async {
                                  final testDriveStatusController =
                                      TextEditingController();
                                  final testDriveTimeController =
                                      TextEditingController();
                                  final modelNameController =
                                      TextEditingController();
                                  final isFinanceController =
                                      TextEditingController();
                                  testDriveStatusController.text = widget
                                      .listValue[index]['tdStatus']
                                      .toString();
                                  testDriveTimeController.text = widget
                                      .listValue[index]['tdTime']
                                      .toString();
                                  modelNameController.text = widget
                                      .listValue[index]['tdModelName']
                                      .toString();
                                  isFinanceController.text =
                                      widget.listValue[index]['isAutoFinance'];

                                  //String leadNo = widget.listValue[index]['leadNo'].toString();
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                        child: TestDriveEditModule(
                                            widget.listValue[index]['leadNo']
                                                .toString(),
                                            widget.listValue[index]
                                                    ['customerName']
                                                .toString(),
                                            widget.listValue[index]['contactNo']
                                                .toString(),
                                            widget.listValue[index]
                                                    ['tdApprovalStatus']
                                                .toString(),
                                            "${widget.listValue[index]['tdRequestedTime'].toString().split(" ")[0]} ${widget.listValue[index]['tdRequestedTime'].toString().split(" ")[1]}",
                                            testDriveStatusController,
                                            testDriveTimeController,
                                            modelNameController,
                                            isFinanceController)),
                                  );
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blueGrey,
                                  size: 35,
                                ),
                              )
                              //Text(value, style: const TextStyle(fontSize: 18.0)),
                              ),
                        ]),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class TestDriveEditModule extends StatefulWidget {
  final String leadNo;
  final String customerName;
  final String phoneNumber;
  final String testDriveApprovalStatus;
  final String testDriveRequestedTime;
  final TextEditingController testDriveStatusController;
  final TextEditingController testDriveTimeController;
  final TextEditingController modelNameController;
  final TextEditingController isFinanceController;

  const TestDriveEditModule(
      this.leadNo,
      this.customerName,
      this.phoneNumber,
      this.testDriveApprovalStatus,
      this.testDriveRequestedTime,
      this.testDriveStatusController,
      this.testDriveTimeController,
      this.modelNameController,
      this.isFinanceController,
      {super.key});

  @override
  State<TestDriveEditModule> createState() => _TestDriveEditModuleState();
}

class _TestDriveEditModuleState extends State<TestDriveEditModule> {
  @override
  initState() {
    super.initState();
    getAPIData();
  }

  final modelNameControllerMid = TextEditingController();
  List testDriveStatusList = ['', 'PENDING', 'DONE'];
  List isFinanceList = ['', 'YES', 'NO'];
  List modelList = [''];
  bool isUploading = false;

  getAPIData() async {
    var data = await getData();

    setState(() {
      modelList = data[6];
      print('asdasdasdadasd$modelList');
    });
  }

  Future updateTestDriveData() async {
    String localURL = Constants.globalURL;
    String employID = Constants.employeeId;
    var response = await http.post(
      Uri.parse('$localURL/updateTestDriveData'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'leadNo': widget.leadNo,
          'tdModelName': widget.modelNameController.text,
          'tdStatus': widget.testDriveStatusController.text,
          'tdTime': widget.testDriveTimeController.text,
          'isAutoFinance': widget.isFinanceController.text,
          'userID': employID
        },
      ),
    );
    print(json.decode(response.body).toString());
    if (response.statusCode == 200) {
      if (json.decode(response.body)['result'].toLowerCase().trim() ==
          'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Saved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/landingPage');
        // Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Server issues!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding:
              const EdgeInsets.only(left: 5, top: 20, bottom: 20, right: 5),
          child: Column(
            children: [
              textShowFieldWidget('Lead No', widget.leadNo),
              textShowFieldWidget('Customer Name', widget.customerName),
              textShowFieldWidget('Customer Contact', widget.phoneNumber),
              textShowFieldWidget(
                  'Test-Drive Approval Status', widget.testDriveApprovalStatus),
              textShowFieldWidget(
                  'Test-Drive Requested Time', widget.testDriveRequestedTime),
              // (test drive statys condtion)
              (widget.testDriveStatusController.text == 'DONE')
                  ? Column(
                      children: [
                        textShowFieldWidget('Test-Drive Status*',
                            widget.testDriveStatusController.text),
                        textShowFieldWidget('Test-Drive Time*',
                            widget.testDriveTimeController.text),
                        textShowFieldWidget(
                            'Model Name*', widget.modelNameController.text),
                      ],
                    )
                  : Column(
                      children: [
                        DropDownWidget(
                          'What will be the test-drive status?* :',
                          'Test-Drive Status* :',
                          testDriveStatusList,
                          widget.testDriveStatusController,
                        ),
                        TimePickerWidget('Test-Drive Time*', '',
                            widget.testDriveTimeController),
                        DropDownWidget('Select Model Name', 'Select Model Name',
                            modelList, modelNameControllerMid),
                        textShowFieldWidget(
                            'Model Name', widget.modelNameController.text),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5, bottom: 5),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (modelNameControllerMid.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Select a model name..',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    } else {
                                      if (widget.modelNameController.text
                                          .isNotEmpty) {
                                        setState(() {
                                          widget.modelNameController.text =
                                              '${widget.modelNameController.text} , ${modelNameControllerMid.text}';
                                          modelNameControllerMid.text = '';
                                        });
                                      } else {
                                        setState(() {
                                          widget.modelNameController.text =
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      //shadowColor: Colors.lightBlueAccent,
                                      color: Colors.blue[800],
                                      elevation: 7.0,
                                      child: const Center(
                                        child: Text(
                                          "Add Model",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
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
                                        widget.modelNameController.text = '';
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
                                        child: const Center(
                                          child: Text(
                                            "Cancel All\nModel",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal),
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
                      ],
                    ),

              DropDownWidget(
                'Is this Auto Finance?* ',
                'Finance* :',
                isFinanceList,
                widget.isFinanceController,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.testDriveStatusController.text == 'DONE' &&
                        widget.testDriveTimeController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Input Test-Drive Time...',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    } else {
                      if (!isUploading) {
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
                        setState(() {
                          isUploading = true;
                        });
                        await updateTestDriveData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please Wait before sending another request..',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
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
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class TimePickerWidget extends StatefulWidget {
  final String title;
  final String date;
  final TextEditingController timeController;
  const TimePickerWidget(this.title, this.date, this.timeController,
      {super.key});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 0.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlueAccent,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () async {
            final TimeOfDay? tdDate = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                initialEntryMode: TimePickerEntryMode.dial);
            if (tdDate != null) {
              setState(() {
                if (widget.date == '') {
                  widget.timeController.text =
                      '${DateTime.now().toString().split(' ')[0]} ${tdDate.toString().split('(')[1].split(')')[0]}:00';
                } else {
                  widget.timeController.text =
                      '${tdDate.toString().split('(')[1].split(')')[0]}:00';
                }
              });
            }
          },
          child: RichText(
            text: TextSpan(
                text: '${widget.title} : ',
                style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.timeController.text,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final String title;
  final TextEditingController dateController;
  const DatePickerWidget(this.title, this.dateController, {super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 0.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlueAccent,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () async {
            final DateTime? midDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2030));
            if (midDate != null) {
              setState(() {
                widget.dateController.text = midDate.toString().split(' ')[0];
              });
            }
          },
          child: RichText(
            text: TextSpan(
                text: '${widget.title} : ',
                style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.dateController.text,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DropDownWidget extends StatefulWidget {
  final String unselectedTitle;
  final String selectedTitle;
  List<dynamic> listValue = [];
  final TextEditingController dropDownController;
  DropDownWidget(this.unselectedTitle, this.selectedTitle, this.listValue,
      this.dropDownController,
      {super.key});
  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            (widget.dropDownController.text.isEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 15),
                    child: Text(
                      widget.unselectedTitle,
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8, left: 15),
                    child: Text(
                      widget.selectedTitle,
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            DropdownButton<String>(
              isExpanded: true,
              padding: const EdgeInsets.only(top: 0, left: 15, right: 20),
              value: widget.dropDownController.text,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 18,
              elevation: 0,
              style: const TextStyle(color: Colors.blue),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  widget.dropDownController.text = value!;
                });
              },
              items: widget.listValue.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
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
    );
  }
}

// ignore: must_be_immutable
class ImageCaptureWidget extends StatefulWidget {
  final String title;
  File? imagePath;
  ImageCaptureWidget(this.title, this.imagePath, {super.key});

  @override
  State<ImageCaptureWidget> createState() => _ImageCaptureWidgetState();
}

class _ImageCaptureWidgetState extends State<ImageCaptureWidget> {
  Future pickImageFromCamera() async {
    final capturedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {});
    return File(capturedImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(3),
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
            GestureDetector(
                onTap: () async {
                  widget.imagePath = await pickImageFromCamera();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 5, bottom: 5),
                  child: RichText(
                    text: TextSpan(
                      // style: Theme.of(context).textTheme.body1,
                      children: [
                        TextSpan(
                          text: '${widget.title} :   ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                              fontSize: 16),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: widget.imagePath == null
                              ? const Icon(
                                  // <-- Icon
                                  Icons.camera_alt_outlined,
                                  size: 30.0,

                                  color: Colors.lightBlueAccent,
                                )
                              : const Icon(
                                  // <-- Icon
                                  Icons.cameraswitch_outlined,
                                  size: 20.0,
                                  color: Colors.lightBlueAccent,
                                ),
                        ),
                      ],
                    ),
                  ),
                )),
            widget.imagePath != null
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            widget.imagePath != null
                ? Image.file(widget.imagePath!)
                : Container()
          ],
        ),
      ),
    );
  }
}

class PopUpWidget extends StatefulWidget {
  final String leadNo;
  final String phoneNumber;
  final String companyName;
  final String customerName;
  final String allSearch;
  //final Function callBackFunction;
  const PopUpWidget(this.leadNo, this.customerName, this.phoneNumber,
      this.companyName, this.allSearch,
      {super.key}
      //    {super.key, required this.callBackFunction}
      //  ,{Key? key, required this.callBackFunction}
      );

  @override
  State<PopUpWidget> createState() => _PopUpWidgetState();
}

class _PopUpWidgetState extends State<PopUpWidget> {
  @override
  void initState() {
    super.initState();
    checkLead();
  }

  late var statusValue;
  bool isSearching = false;

  checkLead() async {
    statusValue = await getLeadSearchData(
      widget.customerName,
      widget.phoneNumber,
      widget.companyName,
      widget.leadNo,
      '',
      '',
      '',
      widget.allSearch,
      '',
    );
    if (statusValue.isEmpty) {
      Constants.isDataAvailable = false;
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
      Navigator.of(context).pop();
    }
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      // width: 800,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          (isSearching)
              ? Expanded(
                  child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListViewWidget(statusValue, true, false),
                    ],
                  ),
                ))
              : const Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class ProductTable {
  String? id;
  String? productName;
  String? productModel;
  String? quantity;
  String? unitPrice;
  String? prospectType;
  String? isNew;
  String? isDeleted;

  ProductTable(
    this.id,
    this.productName,
    this.productModel,
    this.quantity,
    this.unitPrice,
    this.prospectType,
    this.isNew,
    this.isDeleted,
  );
}

class Product_Json {
  Product_Json({
    String? leadNo,
    List<Todo>? itemDetails,
  }) {
    _leadNo = leadNo;
    _itemDetails = itemDetails;
  }

  Product_Json.fromJson(dynamic json) {
    _leadNo = json['leadNo'];

    if (json['itemDetails'] != null) {
      _itemDetails = [];
      json['itemDetails'].forEach((v) {
        _itemDetails?.add(Todo.fromJson(v));
      });
    }
  }
  String? _leadNo;
  List<Todo>? _itemDetails;

  String? get leadNo => _leadNo;
  List<Todo>? get itemDetails => _itemDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leadNo'] = _leadNo;
    if (_itemDetails != null) {
      map['itemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Todo {
  Todo({
    String? id,
    String? productName,
    String? productModel,
    String? quantity,
    String? unitPrice,
    String? prospectType,
    String? isNew,
    String? isDeleted,
  }) {
    _id = id;
    _productName = productName;
    _productModel = productModel;
    _quantity = quantity;
    _unitPrice = unitPrice;
    _prospectType = prospectType;
    _isNew = isNew;
    _isDeleted = isDeleted;
  }

  Todo.fromJson(dynamic json) {
    _id = json['id'];
    _productName = json['productName'];
    _productModel = json['productModel'];
    _quantity = json['quantity'];
    _unitPrice = json['unitPrice'];
    _prospectType = json['prospectType'];
    _isNew = json['isNew'];
    _isDeleted = json['isDeleted'];
  }
  String? _id;
  String? _productName;
  String? _productModel;
  String? _quantity;
  String? _unitPrice;
  String? _prospectType;
  String? _isNew;
  String? _isDeleted;

  String? get id => _id;
  String? get productName => _productName;
  String? get productModel => _productModel;
  String? get quantity => _quantity;
  String? get unitPrice => _unitPrice;
  String? get prospectType => _prospectType;
  String? get isNew => _isNew;
  String? get isDeleted => _isDeleted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['productName'] = _productName;
    map['productModel'] = _productModel;
    map['quantity'] = _quantity;
    map['unitPrice'] = _unitPrice;
    map['prospectType'] = _prospectType;
    map['isNew'] = _isNew;
    map['isDeleted'] = _isDeleted;
    return map;
  }
}
