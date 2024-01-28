import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';

class DSIFormListModule extends StatefulWidget {
  const DSIFormListModule({Key? key}) : super(key: key);

  @override
  State<DSIFormListModule> createState() => _DSIFormListModuleState();
}

class _DSIFormListModuleState extends State<DSIFormListModule> {
  bool isSearching = false;
  late var statusValue;
  bool isSearched = false;

  final roController = TextEditingController();

  setLoadingScreen() async {
    setState(() {
      isSearching = true;
    });

    statusValue = await getDSIFormList(roController.text);
    print(statusValue.toString());
    // statusValue = await getLeadSearchData(phoneNumber, companyName, leadNo, stepType, toDate, fromDate, allSearch,)

    setState(() {
      if (statusValue.length == 0) {
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
        roController.clear();
        isSearched = true;
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
              textTypeFieldWidget('RO No*', roController, false),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        roController.text.isNotEmpty
                            ? setLoadingScreen()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Input More Than 5 Character!!',
                                    textAlign: TextAlign.center,
                                    style:
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
                  : isSearched
                      ? Column(
                          children: [
                            textShowFieldWidget('Repair Order No',
                                statusValue['repairOrderNo'].toString()),
                            textShowFieldWidget('Customer Name',
                                statusValue['customerName'].toString()),
                            textShowFieldWidget('Registration No',
                                statusValue['registrationNo'].toString()),
                            textShowFieldWidget('Car Model',
                                statusValue['carModel'].toString()),
                            textShowFieldWidget(
                                'SA Name', statusValue['saName'].toString()),
                            textShowFieldWidget('Form Type',
                                statusValue['formType'].toString()),
                            textShowFieldWidget('Attended Promptly Rating',
                                statusValue['answer1'].toString()),
                            textShowFieldWidget('Work Done On Time Rating',
                                statusValue['answer2'].toString()),
                            textShowFieldWidget('Cleanliness Rating',
                                statusValue['answer3'].toString()),
                            textShowFieldWidget('Cleanliness Remarks',
                                statusValue['answer3Remarks'].toString()),
                            textShowFieldWidget(
                                'Waiting Area Comfortability Rating',
                                statusValue['answer4'].toString()),
                            textShowFieldWidget(
                                'Waiting Area Comfortability Remarks',
                                statusValue['answer4Remarks'].toString()),
                            textShowFieldWidget('Convenient Parking Rating',
                                statusValue['answer5'].toString()),
                            textShowFieldWidget('Convenient Parking Remarks',
                                statusValue['answer5Remarks'].toString()),
                            textShowFieldWidget('Washing & Cleaning Rating',
                                statusValue['answer6'].toString()),
                            textShowFieldWidget('Washing & Cleaning Remarks',
                                statusValue['answer6Remarks'].toString()),
                            textShowFieldWidget(
                                'Comment on Service & Repair Charges',
                                statusValue['answer7'].toString()),
                            textShowFieldWidget(
                                'Service Advisor Explanation Rating',
                                statusValue['answer8'].toString()),
                            textShowFieldWidget(
                                'Overall Interaction & Experience Rating',
                                statusValue['answer9'].toString()),
                            textShowFieldWidget('Name of Referred Person',
                                statusValue['answer10'].toString()),
                            textShowFieldWidget(
                                'Feedback', statusValue['feedBack'].toString()),
                          ],
                        )
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
