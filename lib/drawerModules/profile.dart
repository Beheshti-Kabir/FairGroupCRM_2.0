import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileModule extends StatefulWidget {
  const ProfileModule({Key? key}) : super(key: key);

  @override
  State<ProfileModule> createState() => _ProfileModuleState();
}

class _ProfileModuleState extends State<ProfileModule> {
  String employID = '';
  String employName = '';
  String employEmail = '';
  String employContact = '';
  String employSBU = '';
  String midSBU = '';
  @override
  initState() {
    super.initState();
    getEmployInfo();
  }

  getEmployInfo() async {
    employName = await getLocalEmployeeName();
    employID = await getLocalEmployeeID();
    employContact = await getLocalEmployeeContact();
    employEmail = await getLocalEmployeeEmail();
    midSBU = await getLocalEmployeeSBU();
    switch (midSBU) {
      case 'FTL':
        employSBU = 'Fair Technology Limited (FTL)';
        break;
      case 'FEL':
        employSBU = 'Fair Electronics Limited (FEL)';
        break;
      case 'FDL':
        employSBU = 'Fair Distribution Limited (FDL)';
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double iconSizee = 30;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Stack(
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/man.png'))),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.blue,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Text(
                        employName,
                        style: GoogleFonts.mcLaren(
                            color: Colors.black, fontSize: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home_repair_service_outlined,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Text(
                        employSBU,
                        style: GoogleFonts.mcLaren(
                            color: Colors.black, fontSize: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Text(
                        employEmail,
                        style: GoogleFonts.mcLaren(
                            color: Colors.black, fontSize: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      employContact,
                      style: GoogleFonts.mcLaren(
                          color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.badge_outlined,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      employID,
                      style: GoogleFonts.mcLaren(
                          color: Colors.black, fontSize: 20),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.blue,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Administrator Information",
                      style: GoogleFonts.mcLaren(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Text(
                        'Rahmat Ullah Farhad',
                        style: GoogleFonts.mcLaren(
                            color: Colors.black, fontSize: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.home_repair_service_outlined,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Text(
                        'Information Technology Software Support',
                        style: GoogleFonts.mcLaren(
                            color: Colors.black, fontSize: 20),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'rahmat.u@fdl.com.bd',
                      style: GoogleFonts.mcLaren(
                          color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: iconSizee,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '01777702090',
                      style: GoogleFonts.mcLaren(
                          color: Colors.black, fontSize: 20),
                    )
                  ],
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }
}
