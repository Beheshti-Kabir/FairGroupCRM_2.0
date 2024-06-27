import 'dart:convert';
import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:path/path.dart';

final productNameController = TextEditingController();
final productModelController = TextEditingController();
final productStockController = TextEditingController();
final quantityController = TextEditingController();
final unitPriceController = TextEditingController();
final prospectTypeCrontroller = TextEditingController();

int productListNumber = 0;

bool productLoaded = false;
late bool isNew;
late bool isDeleted;

List productNameList = [];
List productPriceList = [];
List productModelList = [];
List productSKUList = [];
List<String> prospectTypeList = ['', 'HOT', 'WARM', 'COLD'];

class NewLeadModule extends StatefulWidget {
  const NewLeadModule({Key? key}) : super(key: key);

  @override
  State<NewLeadModule> createState() => _NewLeadModuleState();
}

class _NewLeadModuleState extends State<NewLeadModule> {
  final phoneNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final customerNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final customerDOBController = TextEditingController();
  final leadCategoryController = TextEditingController();
  final professionController = TextEditingController();
  final paymentMethodController = TextEditingController();
  final remarksController = TextEditingController();
  final leadSourceController = TextEditingController();
  final fincanceController = TextEditingController();
  final salesPersionController = TextEditingController();
  final nextFollowUpDateController = TextEditingController();
  final bsoController = TextEditingController();
  final tentativePurchaseDateController = TextEditingController();
  final districtNameController = TextEditingController();
  final currentCarNameController = TextEditingController();
  final verticalController = TextEditingController();
  final coppiedFromController = TextEditingController();

  bool phoneNumberValidator = false;
  bool companyNameValidator = false;
  bool customerNameValidator = false;
  bool currentCarNameValidator = false;
  bool emailValidator = false;
  bool addressValidator = false;
  bool remarksValidator = false;
  bool isSaved = false;
  String sbu = '';

  List leadCategoryList = ['', 'CASH', 'HP', 'CARD', 'MFS', 'DEALER'];
  List verticalList = [
    '',
    'BFSI',
    'NGO & MFI',
    'RMG & TEXTILE',
    'PHARMA & AGRO',
    'HOSPITAL & CLINICS',
    'EDUCATION',
    'NEWS & MEDIA',
    'FMCG',
    'TELCO, ISP & ITES',
    'LOGISTICS & TRANSPORTATION',
    'HOSPITALITY & TOURISM',
    'GOVT. & DEFENSE',
    'ENERGY & POWER',
    'REAL-ESTATE & CONSTRUCTION',
    'CTG- RMG & SHIPPING',
    'CTG- FMCG & OTHERS',
    'OTHERS',
    'SHOWROOM'
  ];
  List districtList = [
    '',
    'Bagerhat District',
    'Bandarban District',
    'Barguna District',
    'Barisal District',
    'Bhola District',
    'Bogra District',
    'Brahmanbaria District',
    'Chandpur District',
    'Chapai Nawabganj District',
    'Chittagong District',
    'Chuadanga District',
    'Comilla District',
    'Cox\'s Bazar District',
    'Dhaka District',
    'Dinajpur District',
    'Faridpur District',
    'Feni District',
    'Gaibandha District',
    'Gazipur District',
    'Gopalganj District',
    'Habiganj District',
    'Jamalpur District',
    'Jessore District',
    'Jhalokati District',
    'Jhenaidah District',
    'Joypurhat District',
    'Khagrachari District',
    'Khulna District',
    'Kishoreganj District',
    'Kurigram District',
    'Kushtia District',
    'Lakshmipur District',
    'Lalmonirhat District',
    'Madaripur District',
    'Magura District',
    'Manikganj District',
    'Meherpur District',
    'Moulvibazar District',
    'Munshiganj District',
    'Mymensingh District',
    'Mymensingh District',
    'Naogaon District',
    'Narail District',
    'Narayanganj District',
    'Narsingdi District',
    'Natore District',
    'Netrokona District',
    'Nilphamari District',
    'Noakhali District',
    'Pabna District',
    'Panchagarh District',
    'Patuakhali District',
    'Pirojpur District',
    'Rajbari District',
    'Rajshahi District',
    'Rangamati District',
    'Rangpur District',
    'Satkhira District',
    'Shariatpur District',
    'Sherpur District',
    'Sirajganj District',
    'Sunamganj District',
    'Sylhet District',
    'Tangail District',
    'Thakurgaon District',
  ];
  List financeList = ['', 'YES', 'NO'];
  List professionList = [''];
  List paymentMethodList = [''];
  List salesPersonList = [''];
  List leadSourceList = [''];
  List productNameList = [];
  List productPriceList = [];
  List productModelList = [];
  List productSKUList = [];

  @override
  void initState() {
    super.initState();
    Constants.selectedSearhed = false;
    getSBU();

    prepareData();
  }

  getSBU() async {
    sbu = await getLocalEmployeeSBU();
  }

  prepareData() async {
    // [[leadStatusList],[leadSourceList],[salesPersonList],[paymentMethodList],[professionList]]

    bsoController.text = await getLocalEmployeeSBU();
    var data = await getData();
    setState(() {
      professionList = data[4];
      paymentMethodList = data[3];
      salesPersonList = data[2];
      leadSourceList = data[1];
    });
  }

  refresh() async {
    customerNameController.text = Constants.selectedCustomerName;
    companyNameController.text = Constants.selectedCompanyName;
    coppiedFromController.text = Constants.selectedcoppiedFrom;
    if (!Constants.isDataAvailable) {
      customerNameController.text = '';
      companyNameController.text = '';
      Constants.selectedSearhed = true;
    }
    setState(() {});
  }

  formValidator() {
    setState(() {
      if (phoneNumberController.text.isEmpty) {
        phoneNumberValidator = true;
      } else {
        phoneNumberValidator = false;
      }
      if (customerNameController.text.isEmpty) {
        customerNameValidator = true;
      } else {
        customerNameValidator = false;
      }

      if (companyNameController.text.isEmpty) {
        companyNameValidator = true;
      } else {
        companyNameValidator = false;
      }
      if (addressController.text.isEmpty) {
        addressValidator = true;
      } else {
        addressValidator = false;
      }
      if (emailController.text.isEmpty) {
        emailValidator = true;
      } else {
        emailValidator = false;
      }
      if (remarksController.text.isEmpty) {
        remarksValidator = true;
      } else {
        remarksValidator = false;
      }
      if (currentCarNameController.text.isEmpty) {
        currentCarNameValidator = true;
      } else {
        currentCarNameValidator = false;
      }
    });
    if (!phoneNumberValidator &&
        !customerNameValidator &&
        !companyNameValidator &&
        !addressValidator &&
        !emailValidator &&
        !remarksValidator &&
        !currentCarNameValidator) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> saveLeadInfo() async {
    String localURL = Constants.globalURL;
    String userID = await getLocalEmployeeID();

    var response = await http.post(
      Uri.parse('$localURL/saveLeadInfoNew'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'customerName': customerNameController.text,
          'customerContact': phoneNumberController.text,
          'customerAddress': addressController.text,
          'customerEmail': emailController.text,
          'customerDOB': customerDOBController.text,
          'companyName': companyNameController.text,
          'remark': remarksController.text,
          'profession': professionController.text,
          'salesPerson': salesPersionController.text.split(' ')[0],
          'leadSource': leadSourceController.text,
          'paymentMethod': paymentMethodController.text,
          'isAutoFinance': fincanceController.text,
          'leadCategory': leadCategoryController.text,
          'userID': userID,
          'nextFollowUpDate': nextFollowUpDateController.text,
          'bsoType': bsoController.text,
          'leadProspectType': 'IN-PROGRESS',
          'copiedFrom': coppiedFromController.text,
          'productName': productNameController.text,
          'productModel': productModelController.text,
          'quantity': quantityController.text,
          'unitPrice': unitPriceController.text,
          'prospectType': prospectTypeCrontroller.text,
          'currentCarName': currentCarNameController.text,
          'vertical': verticalController.text,
          'districtName': districtNameController.text,
          'tentativePurchaseDate': tentativePurchaseDateController.text,
        },
      ),
    );

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  ifEmptyCheckFunction() {
    if (professionController.text.isNotEmpty &&
        salesPersionController.text.isNotEmpty &&
        leadSourceController.text.isNotEmpty &&
        remarksController.text.isNotEmpty &&
        fincanceController.text.isNotEmpty &&
        nextFollowUpDateController.text.isNotEmpty &&
        verticalController.text.isNotEmpty &&
        districtNameController.text.isNotEmpty &&
        tentativePurchaseDateController.text.isNotEmpty &&
        productNameController.text.isNotEmpty &&
        productModelController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        unitPriceController.text.isNotEmpty &&
        prospectTypeCrontroller.text.isNotEmpty) {
      return true;
    } else {
      false;
    }
  }

  clearData() {
    phoneNumberController.clear();
    companyNameController.clear();
    customerNameController.clear();
    emailController.clear();
    addressController.clear();
    customerDOBController.clear();
    leadCategoryController.clear();
    professionController.clear();
    paymentMethodController.clear();
    remarksController.clear();
    leadSourceController.clear();
    fincanceController.clear();
    salesPersionController.clear();
    nextFollowUpDateController.clear();
    bsoController.clear();
    coppiedFromController.clear();
    verticalController.clear();
    currentCarNameController.clear();
    districtNameController.clear();
    tentativePurchaseDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (!Constants.selectedSearhed)
            ? Column(
                children: [
                  textTypeFieldWidget(
                      'Company Name', companyNameController, false),
                  Text(
                    'OR',
                    style: GoogleFonts.mcLaren(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                  ),
                  numberTypeFieldWidget(
                      'Phone Number', phoneNumberController, false),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (phoneNumberController.text.isEmpty &&
                            companyNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fill any one field and search..',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mcLaren(
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: PopUpWidget(
                                '', '',
                                phoneNumberController.text,
                                companyNameController.text, 'TRUE',
                                // callBackFunction: refresh(),
                              ),
                            ),
                          );
                          await refresh();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        height: 65.0,
                        width: 90.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              "Search Lead",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mcLaren(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    textTypeFieldWidget('Customer Name*',
                        customerNameController, customerNameValidator),
                    numberTypeFieldWidget('Contact Number*',
                        phoneNumberController, phoneNumberValidator),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Please make sure the number is 11 digit for Bangladeshi Customers. And don\'t use characters like - or + or space in the phone number",
                        style: GoogleFonts.mcLaren(color: Colors.grey),
                      ),
                    ),
                    textTypeFieldWidget('Company Name*', companyNameController,
                        companyNameValidator),
                    textTypeFieldWidget(
                        'Email Address*', emailController, emailValidator),
                    textTypeFieldWidget(
                        'Address*', addressController, addressValidator),
                    DropDownWidget('District Name* ', 'District Name* :',
                        districtList, districtNameController),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Please don't use any special characters like * & # in Address field.",
                        style: GoogleFonts.mcLaren(color: Colors.grey),
                      ),
                    ),
                    DatePickerWidget(
                        'Customer Date of Birth ', customerDOBController),
                    DropDownWidget('Profession* :', 'Profession :',
                        professionList, professionController),
                    textTypeFieldWidget('Current Car Name',
                        currentCarNameController, currentCarNameValidator),
                    DropDownWidget('Lead Category :', 'Lead Category :',
                        leadCategoryList, leadCategoryController),
                    DropDownWidget('Payment Method :', 'Payment Method :',
                        paymentMethodList, paymentMethodController),
                    DropDownWidget('Lead Source* :', 'Lead Source :',
                        leadSourceList, leadSourceController),
                    DropDownWidget('Vertical* :', 'Vertical* :', verticalList,
                        verticalController),
                    DropDownWidget('Finance* :', 'Finance :', financeList,
                        fincanceController),
                    DatePickerWidget(
                        'Next Follow-up Date* ', nextFollowUpDateController),
                    textTypeFieldWidget(
                        'Remarks*', remarksController, remarksValidator),
                    DropDownWidget('Sales Person* :', 'Sales Person* :',
                        salesPersonList, salesPersionController),
                    DatePickerWidget('Tentative Purchase Date',
                        tentativePurchaseDateController),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.blue[500],
                        height: 60.0,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Product Details',
                          style: GoogleFonts.mcLaren(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        productNameController.text = '';
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => const Dialog(
                            child: ProductAddModule(
                                // callBackFunction: refresh(),
                                ),
                          ),
                        );

                        setState(() {});
                      },
                      child: textShowFieldWidget(
                          'Product Name', productNameController.text),
                    ),
                    textShowFieldWidget(
                        'Product Model', productModelController.text),
                    (sbu == 'FTL')
                        ? textShowFieldWidget(
                            'Stock', productStockController.text)
                        : Container(),
                    numberTypeFieldWidget(
                        'Quantity', quantityController, false),
                    numberTypeFieldWidget(
                        'Unit Price', unitPriceController, false),
                    DropDownWidget(
                        'Inquiry Step Type* :',
                        'Inquiry Step Type* :',
                        prospectTypeList,
                        prospectTypeCrontroller),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          bool isValid = formValidator();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Saving..',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mcLaren(
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          bool ifEmpty = ifEmptyCheckFunction();
                          if (isValid && !isSaved && ifEmpty) {
                            setState(() => isSaved = true);
                            var response = await saveLeadInfo();

                            if (response.toLowerCase().trim() == 'success') {
                              await clearData();
                              if (Constants.employeeId
                                  .contains(Constants.agentInitial)) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/agentLandingPage');
                              } else {
                                Navigator.of(context)
                                    .pushReplacementNamed('/landingPage');
                              }
                            } else {
                              setState(() => isSaved = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Server Issue!!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mcLaren(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Some mandatory fields may be missing!!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mcLaren(
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          alignment: Alignment.center,
                          height: 85.0,
                          width: 90.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.lightBlueAccent,
                            color: Colors.blue[800],
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                "Save Lead",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mcLaren(
                                    color: Colors.white, fontSize: 10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ],
    );
  }
}

class ProductAddModule extends StatefulWidget {
  //final Function callBackFunction;
  const ProductAddModule({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductAddModule> createState() => _ProductAddModuleState();
}

class _ProductAddModuleState extends State<ProductAddModule> {
  getProduct() async {
    setState(() {
      productLoaded = false;
      productNameList = [];
      productPriceList = [];
      productModelList = [];
      productSKUList = [];
    });

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getProductList'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getProductList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'productName': productNameController.text,
        }));

    var productListJSON = json.decode(response.body);

    productListNumber = productListJSON.length;

    for (int i = 0; i < productListNumber; i++) {
      productNameList.add(productListJSON[i]['productName'].toString());
      productModelList.add(productListJSON[i]['productDescription'].toString());
      productPriceList.add(productListJSON[i]['productPrice'].toString());
      productSKUList.add(productListJSON[i]['productCode'].toString());
    }

    setState(() {
      productLoaded = true;
    });
  }

  getProductStock(String code) async {
    print("inside getProductStock");

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getProductListStock'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'productCode': code,
          'companyCode': '2000',
        }));

    return json.decode(response.body)[0]['productStock'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 600,
      // width: 200,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextField(
              style: GoogleFonts.mcLaren(),
              controller: productNameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await getProduct();
                    }),
                hintText: 'Type here for product search',
                hintStyle: GoogleFonts.mcLaren(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          (productNameController.text.length > 1)
              ? (productLoaded)
                  ? (productListNumber > 0)
                      ? Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: productListNumber,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    productNameController.text =
                                        productNameList[index];
                                    unitPriceController.text =
                                        productPriceList[index];
                                    productModelController.text =
                                        productModelList[index];
                                    quantityController.text = '1';
                                    productStockController.text = '0';
                                    if (Constants.companyCode == '2000') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Searching For Stock!!\nPlease wait for couple of seconds. ',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.mcLaren(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                      productStockController.text =
                                          getProductStock(productSKUList[index])
                                              .toString();
                                    }

                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          )),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product Name : ${productNameList[index]}',
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product Model : ${productModelList[index]}',
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product Price : ${productPriceList[index]}',
                                                  style: GoogleFonts.mcLaren(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Column(
                          children: [
                            Text(
                              'No Product Found!! \n\n\nPlease Search With A Different Product Name',
                              style: GoogleFonts.mcLaren(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: Text(
                    'Type Minimum 2 Characters \nThen Press Search Button',
                    style: GoogleFonts.mcLaren(),
                    textAlign: TextAlign.center,
                  ),
                )
        ],
      ),
    );
  }
}
