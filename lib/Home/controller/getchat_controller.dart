import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/chat/model/message.dart';
import 'package:get/get.dart';

class getchat_controller extends GetxController{
  getchat_controller(){
    getdata();
  }
  takeid(id1,docid1){
    id=id1;
    docid=docid1;
    update();
  }
  String? id;
  String? docid;
String? message;
  List<Message>messageslist=[];

  void getdata(){

    FirebaseFirestore.instance.collection('user').doc(id).collection('messageprivate').doc(docid).collection('chat').get().then((value){
      for(int x=0;x<value.docs.length;x++){
        messageslist.add(Message.fromJson(value.docs[x]));
        message=messageslist[x].message.toString();
        print('sadness'+messageslist[0].message.toString());

      }


update();
    });
  }
}