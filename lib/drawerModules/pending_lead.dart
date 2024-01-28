import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';

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
    getData();
    statusValue = await getFollowUpData();
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
                    const SizedBox(
                      height: 20.0,
                      // width: 100.0,fa
                    ),
                    ListViewWidget(statusValue, false, false),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    ]);
  }
}
