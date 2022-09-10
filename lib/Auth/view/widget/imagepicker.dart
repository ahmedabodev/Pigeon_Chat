import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';



import 'package:path/path.dart';

import '../../../const.dart';

class CameraScreen extends StatefulWidget {

  @override
  _CameraScreenState createState() => _CameraScreenState();


}

class _CameraScreenState extends State<CameraScreen> {
  Auth_Controller auth_controller =Get.put(Auth_Controller());
  File? imageFile;
  String? fileName;
  final picker = ImagePicker();
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _getFromGallery();
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _getFromCamera();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }


  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print("imageFile----------------------------->$imageFile");

        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print(imageBytes);
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile!.readAsBytesSync();

        final storage = FirebaseStorage.instance.ref().child('users/${Uri.file(imageFile!.path).pathSegments.last}').putFile(imageFile!).then((value){
          value.ref.getDownloadURL().then((value) {
            photo=value;
            auth_controller.boxphoto.write('boxphoto', value);

          });
        });


        print(" code=>>${imageBytes}");
        // updatimge(base64Image, id);
      });
    }
  }
  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        // print("imageFile----------------------------->$imageFile");
        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print("dddd$imageBytes");
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile!.readAsBytesSync();
        final storage = FirebaseStorage.instance.ref().child('users/${Uri.file(imageFile!.path).pathSegments.last}').putFile(imageFile!).then((value){
          value.ref.getDownloadURL().then((value) {
            photo=value;
            print('myphotototototot'+photo.toString());
            auth_controller.boxphoto.write('boxphoto', value);
          });
        });
        // updatimge(base64Image, id);
      });
    }
  }
  @override
  Widget build(BuildContext context) {

// Create a reference to "mountains.jpg"

    print(photo);
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: (){
          _showSelectionDialog(context);

        }, icon:const  Icon(Icons.camera_enhance,color: Colors.blue,),
        ),
        imageFile==null?Image.asset('images/profile.png',height: 100,):CircleAvatar(
          backgroundImage:FileImage(imageFile!,),

       radius: 65,

        ),
      ],
    );
  }
}