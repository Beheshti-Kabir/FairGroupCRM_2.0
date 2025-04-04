import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String employID = '';
  String employName = '';
  @override
  initState() {
    super.initState();
    getEmployInfo();
  }

  getEmployInfo() async {
    employName = await getLocalEmployeeName();
    employID = await getLocalEmployeeID();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[800],
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                //fit: BoxFit.cover,
                image: AssetImage('assets/man.png'),
              ),
            ),
          ),
          Text(
            employName,
            style: //GoogleFonts.mcLaren
                TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            employID,
            style: //GoogleFonts.mcLaren
                TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}
