import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingLeadModule extends StatefulWidget {
  const PendingLeadModule({Key? key}) : super(key: key);

  @override
  State<PendingLeadModule> createState() => _PendingLeadModuleState();
}

class _PendingLeadModuleState extends State<PendingLeadModule> {
  List<dynamic> statusValue = [];

  @override
  initState() {
    super.initState();
    getAPIData();
  }

  getAPIData() async {
    // getData();
    statusValue = await getFollowUpData();
    print(statusValue.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (statusValue.isEmpty) {
      getAPIData();
      setState(() {});
    }
    return Column(children: <Widget>[
      statusValue.isNotEmpty
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                        height: 60.0,
                        //width: MediaQuery.of(context).size.width,
                        child: Material(
                          borderRadius: BorderRadius.circular(25.0),
                          // borderRadius: BorderRadius.(20.0),
                          shadowColor: const Color.fromARGB(255, 65, 133, 250),
                          color: Colors.white,
                          // elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Total Pending Lead\n${statusValue.length.toString()}',
                              style: GoogleFonts.mcLaren(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListViewWidget(statusValue, false, false),
                  ],
                ),
              ),
            )
          : const Column(
              children: [
                SizedBox(
                  height: 20.0,
                  // width: 100.0,fa
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
    ]);
  }
}
