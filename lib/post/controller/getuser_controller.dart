import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:get/get.dart';
class GetUser_Controller extends GetxController{
  GetUser_Controller(){
    getdata();
  }
  // final Auth_Controller auth_controller =Get.put(Auth_Controller());
  String? name ;
  String? photo ;
  String? email ;
  int? Follwers ;
  dynamic showmessage ;
  void getdata(){
    FirebaseFirestore.instance.collection('user').doc(Auth_Controller().boxcheckid.read('boxcheckid')).get().then((value){
      name =value['name'];
      photo =value['photo'];
      email =value['email'];
      Follwers =value['followers'].length;
      update();
    } );
    FirebaseFirestore.instance.collection('user').doc(Auth_Controller().boxcheckid.read('boxcheckid')).snapshots().forEach((element) {
      showmessage =element['showmessage'];

      print('mynameis'+showmessage.toString());
      update();

    }
    );

  }
}