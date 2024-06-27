import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberSearchModule extends StatefulWidget {
  const NumberSearchModule({Key? key}) : super(key: key);

  @override
  State<NumberSearchModule> createState() => _NumberSearchModuleState();
}

class _NumberSearchModuleState extends State<NumberSearchModule> {
  bool isSearching = false;
  bool phoneNoValidate = false;
  bool leadNoValidate = false;
  List<dynamic> statusValue = [];

  final phoneNumberController = TextEditingController();
  final leadNoController = TextEditingController();

  setLoadingScreen() async {
    setState(() {
      isSearching = true;
    });

    statusValue = await getLeadSearchData(
      '',
      phoneNumberController.text,
      '',
      leadNoController.text,
      '',
      '',
      '',
      'FALSE',
      '',
    );

    // statusValue = await getLeadSearchData(phoneNumber, companyName, leadNo, stepType, toDate, fromDate, allSearch,)

    setState(() {
      if (statusValue.isEmpty) {
        isSearching = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'NO DATA IN THIS LEAD MODE...',
              textAlign: TextAlign.center,
              style: GoogleFonts.mcLaren(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else {
        phoneNumberController.clear();
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
              Text(
                'OR',
                style: GoogleFonts.mcLaren(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey),
              ),
              numberTypeFieldWidget(
                  'Customer Number*', phoneNumberController, phoneNoValidate),
              Container(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        phoneNumberController.text.isNotEmpty ||
                                leadNoController.text.isNotEmpty
                            ? setLoadingScreen()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Input Phone Number or Lead No!!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mcLaren(
                                        fontWeight: FontWeight.bold),
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
                          child: Center(
                            child: Text(
                              'Search',
                              style: GoogleFonts.mcLaren(
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
        ),
      )
    ]);
  }
}
