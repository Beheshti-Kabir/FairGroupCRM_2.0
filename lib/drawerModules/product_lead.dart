import 'package:crm_app/utils/api.dart';
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/sesssion_manager.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final phoneNumberController = TextEditingController();
final leadNoController = TextEditingController();
final productNameController = TextEditingController();
final productModelController = TextEditingController();
final productStockController = TextEditingController();
final quantityController = TextEditingController();
final unitPriceController = TextEditingController();
final prospectTypeCrontroller = TextEditingController();

int productListNumber = 0;
int count = 0;

bool productLoaded = false;
late bool isNew;
late bool isDeleted;

List productNameList = [];
List productPriceList = [];
List productModelList = [];
List productSKUList = [];

class ProductModule extends StatefulWidget {
  const ProductModule({Key? key}) : super(key: key);
  @override
  State<ProductModule> createState() => _ProductModuleState();
}

class _ProductModuleState extends State<ProductModule> {
  List<String> prospectTypeList = ['', 'HOT', 'WARM', 'COLD'];
  List<ProductTable> showTable = [];
  List<Todo> jsonSentTable = [];
  //List<Todo> jsonSentTable = [];
  late ProductTable detailsModel;

  bool isSearched = false;

  String sbu = '';
  @override
  void initState() {
    super.initState();
    Constants.selectedSearhed = false;
    getInitialData();
  }

  getInitialData() async {
    phoneNumberController.clear();
    leadNoController.clear();
    sbu = await getLocalEmployeeSBU();
  }

  refresh() async {
    setState(() {});
  }

  addProduct() {
    if (productModelController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        prospectTypeCrontroller.text.isNotEmpty) {
      count += 1;

      // detailsModel = Todo(
      //     productName: productNameController.text,
      //     productModel: productModelController.text,
      //     quantity: quantityController.text,
      //     unitPrice: unitPriceController.text,
      //     prospectType: prospectTypeCrontroller.text,
      //     isNew: 'true',
      //     isDeleted: 'false');

      detailsModel = ProductTable(
          '',
          productNameController.text,
          productModelController.text,
          quantityController.text,
          unitPriceController.text,
          prospectTypeCrontroller.text,
          'true',
          'false');
      showTable.add(detailsModel);
      //jsonSentTable.add(detailsModel);
      clearController();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fill the mandatory fields!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<String> saveLeadProduct(Product_Json newLeadValues) async {
    print('json value=${newLeadValues.toJson()}');
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/saveLeadProduct'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(newLeadValues));

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  void clearController() {
    productNameController.clear();
    productModelController.clear();
    quantityController.clear();
    productStockController.clear();
    unitPriceController.clear();
    prospectTypeCrontroller.clear();
  }

  Widget rowWidget(String title, int flexSize, FontWeight weight, Color color) {
    return Expanded(
      flex: flexSize,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: weight, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (Constants.selectedSearhed)
            ? Column(
                children: [
                  textShowFieldWidget('Lead No', Constants.selectedLeadNo),
                  textShowFieldWidget(
                      'Customer Name', Constants.selectedCustomerName),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blue[500],
                      height: 60.0,
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Product Details',
                        style: TextStyle(
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
                  numberTypeFieldWidget('Quantity', quantityController, false),
                  numberTypeFieldWidget(
                      'Unit Price', unitPriceController, false),
                  DropDownWidget('Enquity Step Type* :', 'Enquity Step Type* :',
                      prospectTypeList, prospectTypeCrontroller),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        addProduct();
                      },
                      child: SizedBox(
                        height: 30.0,
                        width: 100.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              "Add more items",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 550,
                        //height: 55,
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlueAccent,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // rowWidget('Serial No', 1, FontWeight.bold),
                                  rowWidget('Product Name', 2, FontWeight.bold,
                                      Colors.blue[700]!),
                                  rowWidget('Product Model', 2, FontWeight.bold,
                                      Colors.blue[700]!),
                                  rowWidget('Quantity', 1, FontWeight.bold,
                                      Colors.blue[700]!),
                                  rowWidget('Unit Price', 1, FontWeight.bold,
                                      Colors.blue[700]!),
                                  rowWidget('Prospect Type', 1, FontWeight.bold,
                                      Colors.blue[700]!),
                                  rowWidget('Action', 1, FontWeight.bold,
                                      Colors.blue[700]!),
                                ],
                              ),
                              ListView.builder(
                                itemCount: showTable.length,
                                //scrollDirection: ScrollController:,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var model = showTable[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: (model.isDeleted == 'false')
                                        ? Row(
                                            children: [
                                              // rowWidget((index + 1).toString(),
                                              //     1, FontWeight.normal,Colors.black),
                                              rowWidget(
                                                  model.productName.toString(),
                                                  2,
                                                  FontWeight.normal,
                                                  Colors.black),
                                              rowWidget(
                                                  model.productModel.toString(),
                                                  2,
                                                  FontWeight.normal,
                                                  Colors.black),
                                              rowWidget(
                                                  model.quantity.toString(),
                                                  1,
                                                  FontWeight.normal,
                                                  Colors.black),
                                              rowWidget(
                                                  model.unitPrice.toString(),
                                                  1,
                                                  FontWeight.normal,
                                                  Colors.black),
                                              rowWidget(
                                                  model.prospectType.toString(),
                                                  1,
                                                  FontWeight.normal,
                                                  Colors.black),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    model.isDeleted = 'true';
                                                    // showTable.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  child: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
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
                        jsonSentTable = [];
                        if (productNameController.text.isEmpty) {
                          for (int i = 0; i < showTable.length; i++) {
                            late Todo detailsModelMid = Todo(
                                id: showTable[i].id.toString(),
                                productName:
                                    showTable[i].productName.toString(),
                                productModel:
                                    showTable[i].productModel.toString(),
                                quantity: showTable[i].quantity.toString(),
                                unitPrice: showTable[i].unitPrice.toString(),
                                prospectType:
                                    showTable[i].prospectType.toString(),
                                isNew: showTable[i].isNew.toString(),
                                isDeleted: showTable[i].isDeleted.toString());
                            jsonSentTable.add(detailsModelMid);
                            // jsonSentTable = showTable as List<Todo>;
                          }
                          // jsonSentTable = showTable as List<Todo>;
                          print(leadNoController.text);
                          var newProductValues = Product_Json(
                              leadNo: Constants.selectedLeadNo,
                              itemDetails: jsonSentTable);
                          var response =
                              await saveLeadProduct(newProductValues);
                          if (response.toLowerCase().trim() == 'success') {
                            Navigator.of(context)
                                .pushReplacementNamed('/landingPage');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Server Issue!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        } else {
                          await addProduct();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        alignment: Alignment.center,
                        height: 85.0,
                        width: 130.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              "Upload Products",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Column(
                children: [
                  numberTypeFieldWidget('Lead No', leadNoController, false),
                  const Text(
                    'OR',
                    style: TextStyle(
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
                            leadNoController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fill any one field and search..',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: PopUpWidget(
                                leadNoController.text,
                                phoneNumberController.text, '', 'FALSE',
                                // callBackFunction: refresh(),
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Loading Products!!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          var jsonProduct =
                              await getLeadProduct(Constants.selectedLeadNo);
                          print(jsonProduct.toString());
                          for (int i = 0; i < jsonProduct.length; i++) {
                            detailsModel = ProductTable(
                                jsonProduct[i]['id'].toString(),
                                jsonProduct[i]['productName'].toString(),
                                jsonProduct[i]['description'].toString(),
                                jsonProduct[i]['quantity'].toString(),
                                jsonProduct[i]['unitPrice'].toString(),
                                jsonProduct[i]['prospectType'],
                                'false',
                                'false'
                                // jsonProduct[i]['isNew'],
                                // jsonProduct[i]['isDeleted']
                                );
                            showTable.add(detailsModel);
                          }
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
                          child: const Center(
                            child: Text(
                              "Search Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
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
              controller: productNameController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await getProduct();
                    }),
                hintText: 'Type here for product search',
                hintStyle: const TextStyle(color: Colors.grey),
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
                                        const SnackBar(
                                          content: Text(
                                            'Searching For Stock!!\nPlease wait for couple of seconds. ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                                                  style: const TextStyle(
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
                                                  style: const TextStyle(
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
                                                  style: const TextStyle(
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
                      : const Center(
                          child: Column(
                          children: [
                            Text(
                              'No Product Found!! \n\n\nPlease Search With A Different Product Name',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : const Center(
                  child: Text(
                    'Type Minimum 2 Characters \nThen Press Search Button',
                    textAlign: TextAlign.center,
                  ),
                )
        ],
      ),
    );
  }
}
