import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/const.dart';
import 'package:firebase_testing/mainscreen/controller/main_controller.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:firebase_testing/post/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
   CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}
final _globalKey=GlobalKey<FormState>();
class _CreatePostScreenState extends State<CreatePostScreen> {
final GetUser_Controller getUser_Controller=Get.put(GetUser_Controller());
TextEditingController postcontroller=TextEditingController();
   Auth_Controller auth_controller =Get.put(Auth_Controller());
Main_Controller main_controller =Get.put(Main_Controller());
final Post_Controller post_controller=Get.put(Post_Controller());

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

         // updatimge(base64Image, id);
       });
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff06142b),

      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),

                Row(
                  children: [
                    (getUser_Controller.photo=='null')?const CircleAvatar(
                      radius: 25,
                      backgroundImage:AssetImage('images/profile.png') ,
                      backgroundColor: Colors.black,
                    ):CircleAvatar(radius: 25,
                      backgroundImage:NetworkImage(getUser_Controller.photo!) ,

                    ),
                    const SizedBox(width: 10,),

                    Text(getUser_Controller.name!,style: TextStyle(
                        color: Colors.white
                    ),),
                  ],
                ),
                const SizedBox(height: 15,),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 10, right: 10, top: 5),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: postcontroller,
                              validator: (value) {
                                if (value!.isEmpty&&imageFile==null) {
                                  return 'pls enter your word';
                                }
                              },
                              maxLines: 3,
                              decoration: InputDecoration(

                                  counterStyle: TextStyle(color: Colors.white),
                                  isDense: true,
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                     ),

                                  hintText: 'What in your Mind.....',
                            ),
                          ))),
                    ],
                  ),
                ),
                if(imageFile!=null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: FileImage(imageFile!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              imageFile=null;

                            });
                          },
                          icon: const CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.close,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 15,),
                Divider(
                  color:Colors.grey,
                ),
                 // SizedBox(height: MediaQuery.of(context).size.height/3,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    OutlinedButton(onPressed: (){
                      _showSelectionDialog(context);
                    }, child: Row(
                      children: [
                        Icon(Icons.photo),
                        const SizedBox(width: 5,),
                        Text('add photo',),
                      ],
                    )),
                    OutlinedButton(onPressed: (){
                      if(_globalKey.currentState!.validate()){
                        if(imageFile==null){
                          FirebaseFirestore.instance.collection('post').add({
                            "name":getUser_Controller.name,
                            "photo":getUser_Controller.photo,
                            "email":getUser_Controller.email,
                            "postphoto":'null',
                            "mypost":postcontroller.text,
                            "Time":DateTime.now(),
                            'userid':auth_controller.boxcheckid.read('boxcheckid'),
                            'Comments':[],
                            'Likes':[],

                          });
                          post_controller.getupdata();
                          main_controller.changebottom(0);

                        }else{
                          final storage = FirebaseStorage.instance.ref().child('users/${Uri.file(imageFile!.path).pathSegments.last}').putFile(imageFile!).then((value){
                            value.ref.getDownloadURL().then((value) {
                              FirebaseFirestore.instance.collection('post').add({
                                "name":getUser_Controller.name  ,
                                "photo":getUser_Controller.photo,
                                "email":getUser_Controller.email,
                                "postphoto":value.toString(),
                                "mypost":postcontroller.text,
                                "Time":DateTime.now(),
                                'userid':auth_controller.boxcheckid.read('boxcheckid'),
                                'Comments':[],
                                'Likes':[],
                              }).then((value) {
                                post_controller.getupdata();

                              });
                            });
                          });

                          main_controller.changebottom(0);

                        }

                      }
                      else{



                      }


                    }, child: Row(
                      children: [
                        Icon(Icons.post_add),
                        const SizedBox(width: 5,),
                        Text('Create Post',),
                      ],
                    )),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}
