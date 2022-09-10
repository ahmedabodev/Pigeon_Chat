import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:get/get.dart';

class Follow_Controller extends GetxController{
  Auth_Controller _auth_controller=Get.put(Auth_Controller());

  Follow_Controller(){
    getdata();
  }
  getupdate(){
   getdata();
    update();
  }
  List<dynamic>Follwing=[];
  CollectionReference? message;
  void getdata(){


    FirebaseFirestore.instance
        .collection('user')
        .doc(_auth_controller.boxcheckid.read("boxcheckid"))
        .get()
        .then((value) {
      Follwing=value['followers'];
      update();

    });
    update();
  }
}