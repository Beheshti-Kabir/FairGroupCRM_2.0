// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:crm_app/drawerModules/dashboard.dart';
import 'package:crm_app/drawerModules/dsi_form.dart';
import 'package:crm_app/drawerModules/dsi_form_list.dart';
import 'package:crm_app/drawerModules/lead_search_with_date.dart';
import 'package:crm_app/drawerModules/lead_search_with_number.dart';
import 'package:crm_app/drawerModules/my_head_drawer.dart';
import 'package:crm_app/drawerModules/new_lead.dart';
import 'package:crm_app/drawerModules/new_lead_transaction.dart';
import 'package:crm_app/drawerModules/pending_lead.dart';
import 'package:crm_app/drawerModules/picture_for_lead.dart';
import 'package:crm_app/drawerModules/product_lead.dart';
import 'package:crm_app/drawerModules/profile.dart';
import 'package:crm_app/drawerModules/test_drive.dart';
import 'package:crm_app/login_page.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class _LandingPageState extends State<LandingPage> {
  bool isLoading = false;
  bool gotData = false;

  late dynamic response;
  String version = Constants.version;
  String employID = '';
  String employName = '';
  String titleDashboard = 'DashBoard';

  int selecselectedOptionIndex = 1;
  double buttonWidth = 300;
  double buttonHeight = 50;
  double textSize = 20;
  double iconSizee = 30;

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

  showMenu() {}

  logOut() {
    storeLocalSetEmployeeID(Constants.employeeIDKey, '');
    storeLocalSetLogInStatus(Constants.logInStatusKey, 'fail');
    //Navigator.of(context).pushReplacementNamed('/logInPage');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  onItemTap(int index) {
    setState(() {
      selecselectedOptionIndex = index;
    });
  }

  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    late StatefulWidget container;

    if (currentPage == DrawerSections.profile) {
      container = ProfileModule();
    } else if (currentPage == DrawerSections.dashboard) {
      container = DashBoardModule();
    } else if (currentPage == DrawerSections.newLead) {
      container = NewLeadModule();
    } else if (currentPage == DrawerSections.pendingLead) {
      container = PendingLeadModule();
    } else if (currentPage == DrawerSections.leadSearchNumber) {
      container = NumberSearchModule();
    } else if (currentPage == DrawerSections.leadSearchDate) {
      container = DateSearchModule();
    } else if (currentPage == DrawerSections.dsiForm) {
      container = DSIFormModule();
    } else if (currentPage == DrawerSections.dsiFormList) {
      container = DSIFormListModule();
    } else if (currentPage == DrawerSections.picturePage) {
      container = PictureModule();
    } else if (currentPage == DrawerSections.productPage) {
      container = ProductModule();
    } else if (currentPage == DrawerSections.teshDrivePage) {
      container = TestDriveModule();
    } else if (currentPage == DrawerSections.newLeadTransaction) {
      container = NewLeadTransactionModule();
    }

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          '$titleDashboard For $employID',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 20.0,
        //leading: IconButton(onPressed: showMenu, icon: Icon(Icons.menu)),
        actions: [
          IconButton(
              onPressed: logOut,
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(child: container),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(children: [
        menuItem(2, 'DashBoard', Icons.dashboard_outlined,
            currentPage == DrawerSections.dashboard ? true : false),
        menuItem(3, 'New Lead', Icons.content_paste_go,
            currentPage == DrawerSections.newLead ? true : false),
        menuItem(9, 'Product Page', Icons.shopping_cart_outlined,
            currentPage == DrawerSections.productPage ? true : false),
        menuItem(8, 'Picture Page', Icons.camera_alt_outlined,
            currentPage == DrawerSections.picturePage ? true : false),
        menuItem(11, 'New Lead Transaction', Icons.add_card_sharp,
            currentPage == DrawerSections.newLeadTransaction ? true : false),
        menuItem(10, 'Test-Drive Page', Icons.car_crash_outlined,
            currentPage == DrawerSections.teshDrivePage ? true : false),
        menuItem(4, 'Pending Lead', Icons.pending_actions_sharp,
            currentPage == DrawerSections.pendingLead ? true : false),
        menuItem(5, 'Search Lead With Number', Icons.content_paste_search_sharp,
            currentPage == DrawerSections.leadSearchNumber ? true : false),
        menuItem(6, 'Search Lead Date Wise', Icons.edit_calendar_outlined,
            currentPage == DrawerSections.leadSearchDate ? true : false),
        menuItem(7, 'DSI/PSF Form', Icons.dynamic_form_outlined,
            currentPage == DrawerSections.dsiForm ? true : false),
        menuItem(12, 'DSI/PSF Form List', Icons.format_align_left_sharp,
            currentPage == DrawerSections.dsiFormList ? true : false),
        menuItem(1, 'Profile', Icons.person_2_outlined,
            currentPage == DrawerSections.profile ? true : false),
      ]),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              titleDashboard = 'Profile';
              currentPage = DrawerSections.profile;
            } else if (id == 2) {
              titleDashboard = 'Dashboard';
              currentPage = DrawerSections.dashboard;
            } else if (id == 3) {
              titleDashboard = 'New Lead Create';
              currentPage = DrawerSections.newLead;
            } else if (id == 4) {
              titleDashboard = 'Pending Leads';
              currentPage = DrawerSections.pendingLead;
            } else if (id == 5) {
              titleDashboard = 'Searching Leads';
              currentPage = DrawerSections.leadSearchNumber;
            } else if (id == 6) {
              titleDashboard = 'Searching Leads';
              currentPage = DrawerSections.leadSearchDate;
            } else if (id == 7) {
              titleDashboard = 'DSI/PSF Form';
              currentPage = DrawerSections.dsiForm;
            } else if (id == 8) {
              titleDashboard = 'Picture Page';
              currentPage = DrawerSections.picturePage;
            } else if (id == 9) {
              titleDashboard = 'Product Page';
              currentPage = DrawerSections.productPage;
            } else if (id == 10) {
              titleDashboard = 'Test-Drive Page';
              currentPage = DrawerSections.teshDrivePage;
            } else if (id == 11) {
              titleDashboard = 'New LeadTransaction';
              currentPage = DrawerSections.newLeadTransaction;
            } else if (id == 12) {
              titleDashboard = 'DSI/PSF Form List';
              currentPage = DrawerSections.dsiFormList;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  profile,
  dashboard,
  newLead,
  pendingLead,
  leadSearchNumber,
  leadSearchDate,
  dsiForm,
  picturePage,
  productPage,
  teshDrivePage,
  newLeadTransaction,
  dsiFormList
}
