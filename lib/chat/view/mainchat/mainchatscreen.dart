import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Home/controller/search_controller.dart';
import 'package:firebase_testing/chat/model/mainhome.dart';
import 'package:firebase_testing/chat/model/message.dart';
import 'package:firebase_testing/chat/view/chatscreen.dart';
import 'package:firebase_testing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MainChatScreen extends StatelessWidget {
  MainChatScreen({Key? key}) : super(key: key);
  final Auth_Controller _auth_controller =Get.put(Auth_Controller());
  final Search_Controller search_controller =Get.put(Search_Controller());
  TextEditingController searchcontroller= TextEditingController();
  CollectionReference? message;

  @override
  Widget build(BuildContext context) {
    CollectionReference? user=FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind') ;

    String idgoogle = auth_controller.boxidgoogle.read('boxidgoogle');

    if (auth_controller.boxcheck.read('boxcheck') == true) {
      FirebaseFirestore.instance.collection('user').doc(_auth_controller.boxcheckid.read('boxcheckid')).collection('freind');
    } else {
      FirebaseFirestore.instance.collection('user').doc(idgoogle).collection('freind');

    }
    FirebaseFirestore.instance.collection('user').doc(Auth_Controller().boxcheckid.read('boxcheckid')).update({
      'showmessage':false
    });
    return Scaffold(
      backgroundColor:const Color(0xff061328),


      body: GetBuilder<Search_Controller>(builder: ( controller) {
        return StreamBuilder<QuerySnapshot>(
          stream: user.orderBy('timenow',descending: true,).snapshots(),
          builder: (BuildContext context, snapshot) {
            if(snapshot.hasData){
              List<Mainhome>userlist=[];
              for(int x=0;x<snapshot.data!.docs.length;x++){
                userlist.add(Mainhome.fromJson(snapshot.data!.docs[x]));


              }
              return Column(
                children: [

                  Expanded(child: ListView.builder(

                    itemCount: userlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      DateTime mytime=DateTime.parse(userlist[index].timenow.toDate().toString());
                      String formattedDate = DateFormat('kk:mm').format(mytime);
                      return (userlist.isEmpty)?const Center(child: CircularProgressIndicator(),): InkWell(
                        onTap: (){
                          Get.to(()=>ChatScreen(tokken: userlist[index].token,docid:snapshot.data!.docs[index].reference.id ,name: userlist[index].name.toString(), image:userlist[index].photo.toString(),numberofmessage:userlist[index].numberofmessage),);
                        },
                        child:(_auth_controller.boxemail.read('boxemail')==userlist[index].email.toString()||_auth_controller.boxemailgoogle.read('boxemailgoogle')==userlist[index].email.toString())?const SizedBox(height: 0,width: 0,):
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Card(
                            elevation: 10,
                            color:const Color(0xff0b1b38),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            ((userlist[index].photo.toString()=='null'))?const CircleAvatar(
                                              backgroundImage:AssetImage('images/profile.png',),
                                              backgroundColor: Colors.black,
                                              radius: 30,

                                            ):CircleAvatar(
                                              backgroundImage:NetworkImage(userlist[index].photo.toString()),
                                              radius: 30,

                                            ),
                                            const SizedBox(width: 20,),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(userlist[index].name.toString(),style:const TextStyle(
                                                      color: Colors.white
                                                  ),),
                                                  const SizedBox(height: 10,),
                                                  Text(userlist[index].lastmessage.toString(),style:const TextStyle(
                                                      color: Colors.grey
                                                  ),),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(formattedDate,style:const TextStyle(
                                                    color: Colors.white
                                                ),),
                                                const SizedBox(height: 10,),

                                                (userlist[index].numberofmessage==0)?
                                                SizedBox(height: 0,width: 0,):
                                                const CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: Colors.red,
                                                ),
                                              ],
                                            ),


                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),




                              ],
                            ),
                          ),
                        ),
                      );
                    },)),

                ],
              )
              ;
            }
            else {
              return const Center(child: CircularProgressIndicator(
              ),);
            }
          },);
      },),
    );
  }
}
