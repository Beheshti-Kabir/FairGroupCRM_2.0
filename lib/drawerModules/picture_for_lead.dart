import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:crm_app/utils/constants.dart';
import 'package:crm_app/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureModule extends StatefulWidget {
  const PictureModule({Key? key}) : super(key: key);
  @override
  State<PictureModule> createState() => _PictureModuleState();
}

class _PictureModuleState extends State<PictureModule> {
  File? visitingCardFront;
  File? visitingCardBack;
  File? groupPicture;
  File? selfiePicute;

  final phoneNumberController = TextEditingController();
  final leadNoController = TextEditingController();

  bool isSearched = false;
  @override
  void initState() {
    super.initState();
    Constants.selectedSearhed = false;
    phoneNumberController.clear();
    leadNoController.clear();
  }

  refresh() async {
    setState(() {});
  }

  Future<String> uploadImage() async {
    print(visitingCardFront.toString());
    String localURL = Constants.globalURL;
    String visitingCardFrontBaseimage = '';
    String visitingCardBackBaseimage = '';
    String selfiePictureBaseimage = '';
    String groupPictureBaseimage = '';
    try {
      Uint8List visitingCardFrontImagebytes =
          await visitingCardFront!.readAsBytes(); //convert to bytes
      visitingCardFrontBaseimage = base64.encode(visitingCardFrontImagebytes);
      Uint8List visitingCardBackImagebytes =
          await visitingCardBack!.readAsBytes(); //convert to bytes
      visitingCardBackBaseimage = base64.encode(visitingCardBackImagebytes);
      Uint8List selfieIcmagebytes =
          await selfiePicute!.readAsBytes(); //convert to bytes
      selfiePictureBaseimage = base64.encode(selfieIcmagebytes);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mendatory Picture Missing!!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      //there is error during converting file image to base64 encoding.
    }
    try {
      Uint8List groupImagebytes =
          await groupPicture!.readAsBytes(); //convert to bytes
      groupPictureBaseimage = base64.encode(groupImagebytes);
    } catch (e) {
      groupPictureBaseimage = '';
    }
    var response = await http.post(
      Uri.parse('$localURL/postImage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(
        <String, String>{
          'visitingCardFront': visitingCardFrontBaseimage,
          'visitingCardBack': visitingCardBackBaseimage,
          'groupPicture': groupPictureBaseimage,
          'selfiePicture': selfiePictureBaseimage,
        },
      ),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body)['result'].toString());
      return json.decode(response.body)['result'];
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
      return '';
    }
    // } catch (e) {
    //   print(e.toString());
    //   //there is error during converting file image to base64 encoding.
    // }
    //return 'good';
  }

  Future pickImageFromCamera() async {
    final capturedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {});
    return File(capturedImage!.path);
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
                                visitingCardFront = await pickImageFromCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 5, bottom: 5),
                                child: RichText(
                                  text: TextSpan(
                                    // style: Theme.of(context).textTheme.body1,
                                    children: [
                                      TextSpan(
                                        text: 'Visiting Card Front* :   ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                            fontSize: 16),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: visitingCardFront == null
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
                          visitingCardFront != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          visitingCardFront != null
                              ? Image.file(visitingCardFront!)
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Padding(
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
                                visitingCardBack = await pickImageFromCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 5, bottom: 5),
                                child: RichText(
                                  text: TextSpan(
                                    // style: Theme.of(context).textTheme.body1,
                                    children: [
                                      TextSpan(
                                        text: 'Visiting Card Back* :   ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                            fontSize: 16),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: visitingCardBack == null
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
                          visitingCardBack != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          visitingCardBack != null
                              ? Image.file(visitingCardBack!)
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Padding(
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
                                groupPicture = await pickImageFromCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 5, bottom: 5),
                                child: RichText(
                                  text: TextSpan(
                                    // style: Theme.of(context).textTheme.body1,
                                    children: [
                                      TextSpan(
                                        text: 'Group Picture :   ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                            fontSize: 16),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: groupPicture == null
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
                          groupPicture != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          groupPicture != null
                              ? Image.file(groupPicture!)
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Padding(
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
                                selfiePicute = await pickImageFromCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 5, bottom: 5),
                                child: RichText(
                                  text: TextSpan(
                                    // style: Theme.of(context).textTheme.body1,
                                    children: [
                                      TextSpan(
                                        text: 'Selfie* :   ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700],
                                            fontSize: 16),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: selfiePicute == null
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
                          selfiePicute != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          selfiePicute != null
                              ? Image.file(selfiePicute!)
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Uploading..',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        var response = await uploadImage();

                        if (response.toString().toLowerCase().trim() ==
                            'success') {
                          Navigator.of(context)
                              .pushReplacementNamed('/landingPage');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed!!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        height: 65.0,
                        width: 100.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.lightBlueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              "Upload Pictures",
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
                                leadNoController.text, '',
                                phoneNumberController.text, '', 'FALSE',
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
