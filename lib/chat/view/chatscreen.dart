import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/chat/model/message.dart';
import 'package:firebase_testing/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class ChatScreen extends StatefulWidget {
  String? docid;
  String? name;
  String? image;
  String? tokken;
  dynamic numberofmessage;

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  ChatScreen(
      {required this.docid,
      required this.name,
      required this.image,
      required this.tokken,
      required this.numberofmessage
      });
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  getdatahome(String body,String names,String myimage,String myid,token)async{
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAs17d1hc:APA91bHMntTxkjvrMLCWO34t_tlR1ttGE47I0eNJiav6giUt9Y5PI0GgNOL0YvaKvT2jZdB8DHDdj789s22WfN5ces4FFWmSybqscRNIQcVuu3ixP2OiGBKtyuwzPFvoVpwbe3oOehbV',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title':names,
            'sound':'default',
      "android":{
      'notification': <String, dynamic>{
      "imageUrl": 'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send%20HTTP/1.1',
      'sound':"true",
      }

      },

      },
          "android": {
            "notification": {
              "imageUrl": 'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send%20HTTP/1.1'
            }
          },
          "apns": {
            "payload": {
              "aps": {
                'mutable-content': 1
              }
            },
            "fcm_options": {
              "image": 'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send%20HTTP/1.1'
            }
          },
          "webpush": {
            "headers": {
              "image": 'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send%20HTTP/1.1'
            }
          },
          'to': token,
        },
      ),
    );
  }

  final Auth_Controller auth_controller = Get.put(Auth_Controller());

  TextEditingController sendcontroller = TextEditingController();

  final _controller = ScrollController();

  void _scrollDown() {
    setState(() {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });

    print('Build Completed1');
  }
  pop(){
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Future.delayed(Duration(seconds: 1), () => _scrollDown());
    });
  }

  @override
  Widget build(BuildContext context) {
    String idgoogle = auth_controller.boxidgoogle.read('boxidgoogle');

    String id = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference? messages;
    CollectionReference? messagesrecives;
    print('my checkkk' + auth_controller.boxcheck.read('boxcheck').toString());
    print('my checkkk' + idgoogle);
    if (auth_controller.boxcheck.read('boxcheck') == true) {
      messages = FirebaseFirestore.instance
          .collection('user')
          .doc(widget.docid)
          .collection('messageprivate')
          .doc(id)
          .collection('chat');
      messagesrecives = FirebaseFirestore.instance
          .collection('user')
          .doc(id)
          .collection('messageprivate')
          .doc(widget.docid)
          .collection('chat');
    } else {
      messages = FirebaseFirestore.instance
          .collection('user')
          .doc(widget.docid)
          .collection('messageprivate')
          .doc(idgoogle)
          .collection('chat');
      messagesrecives = FirebaseFirestore.instance
          .collection('user')
          .doc(idgoogle)
          .collection('messageprivate')
          .doc(widget.docid)
          .collection('chat');
    }
if(auth_controller.boxcheckid.read("boxcheckid")!=widget.docid.toString()){
  FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind').doc(widget.docid).update({
    "numberofmessage":0,

  });
}else{}
    return Scaffold(
      backgroundColor: Color(0xff061328),
      appBar: AppBar(
        backgroundColor: Color(0xff06142b),
        title: Row(
          children: [
            (widget.image == 'null')
                ? CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/profile.png',
                    ),
                    backgroundColor: Colors.black,
                    radius: 20,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(widget.image!),
                    radius: 20,
                  ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )
          ],
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          final bool connected = connectivity!= ConnectivityResult.none;
          if(connected){
            return  Form(
              child: StreamBuilder<QuerySnapshot>(
                stream: messages!.orderBy('createdAt', descending: false).snapshots(),
                builder: (BuildContext context, snapshot) {
                  var email = auth_controller.firebaseAuth.currentUser!.email;

                  if (snapshot.hasData) {
                    List<Message> messageslist = [];
                    for (int x = 0; x < snapshot.data!.docs.length; x++) {
                      messageslist.add(Message.fromJson(snapshot.data!.docs[x]));
                    }

                    snapshot.data!.docs.forEach((element) {
                      element.data();
                    });
                    return Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                              controller: _controller,
                              itemCount: messageslist.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (messageslist.isNotEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      (messageslist[index].email == email)
                                          ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, left: 50, top: 5),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onLongPress: () {
                                              showModalBottomSheet(
                                                  context: context, builder: (BuildContext context)
                                              {
                                                return Container(
                                                  color:const Color(0xff061328),
                                                  height: 70,
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: (){
                                                            messagesrecives!.get().then((value) {
                                                              for(int x=0;x<value.docs.length;x++){
                                                                if(value.docs[x]['message'].toString()==snapshot.data!.docs[index]['message'].toString()&&value.docs[x]['delete']==snapshot.data!.docs[index]['delete']){
                                                                  print('mostafaa');
                                                                  messages!
                                                                      .doc(snapshot.data!.docs[index].id
                                                                      .toString())
                                                                      .delete();
                                                                  messagesrecives!.doc(value.docs[x].id
                                                                      .toString())
                                                                      .delete();
                                                                  Get.back();

                                                                }else{
                                                                  print('nothing1');
                                                                }
                                                              }
                                                            });



                                                          },
                                                          child: Column(
                                                            children: const [
                                                              SizedBox(height: 10,),
                                                              Icon(Icons.delete,color:   Color(0xff4d67ee),size: 30),
                                                              Text("Delete",style:  TextStyle(
                                                                  color: Colors.white
                                                              )),

                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: (){
                                                            Get.back();
                                                          },
                                                          child: Column(
                                                            children: const [
                                                              SizedBox(height: 10,),
                                                              Icon(Icons.cancel,color:   Color(0xff4d67ee),size: 30),
                                                              Text("Cancel",style:  TextStyle(
                                                                  color: Colors.white
                                                              )),

                                                            ],
                                                          ),
                                                        ),

                                                      ]),
                                                );
                                              });

                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              color: Color(0xff2077ff),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  messageslist[index]
                                                      .message
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                          : Padding(
                                        padding: const EdgeInsets.only(
                                            right: 50, left: 5, top: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            color: Color(0xff0b1b38),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                messageslist[index]
                                                    .message
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )),
                        Container(
                          color: Color(0xff10192b),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, left: 10, right: 10, top: 5),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      controller: sendcontroller,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'pls Enter you Email';
                                        }
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                        } else {
                                          var delete=messageslist.length+1;

                                          messages!.add({
                                            'message': value,
                                            'createdAt': DateTime.now(),
                                            'email': email,
                                            'delete':delete

                                          });
                                          messagesrecives!.add({
                                            'message': sendcontroller.text,
                                            'createdAt': DateTime.now(),
                                            'email': email,
                                            'delete':delete

                                          });
                                          FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).update({
                                            'showmessage':true,
                                          });
                                          if (auth_controller.boxcheck.read('boxcheck') == true) {
                                            String nameacc='';
                                            FirebaseFirestore.instance
                                                .collection('user').doc(id).get().then((value) {
                                              nameacc=value['name'].toString();

                                              getdatahome(sendcontroller.text,value['name'],widget.image.toString(),id,widget.tokken);
                                              FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind').doc(widget.docid).update({
                                                'lastmessage':sendcontroller.text,
                                                'timenow':DateTime.now(),
                                                "numberofmessage":0,

                                              });
                                              FirebaseFirestore.instance.collection('user').doc(widget.docid).collection('freind').doc(auth_controller.boxcheckid.read('boxcheckid')).update({
                                                'lastmessage':sendcontroller.text,
                                                'timenow':DateTime.now(),
                                                "numberofmessage":1,



                                              });
                                              sendcontroller.clear();

                                            });
                                          } else {
                                            getdatahome(sendcontroller.text,auth_controller.boxnamegoogle.read('boxnamegoogle'),widget.image.toString(),id,widget.tokken);
                                            FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind').doc(widget.docid).update({
                                              'lastmessage':sendcontroller.text,
                                              'timenow':DateTime.now(),
                                              "numberofmessage":0,


                                            });
                                            FirebaseFirestore.instance.collection('user').doc(widget.docid).collection('freind').doc(auth_controller.boxcheckid.read('boxcheckid')).update({
                                              'lastmessage':sendcontroller.text,
                                              'timenow':DateTime.now(),
                                              "numberofmessage":1,

                                            });
                                            sendcontroller.clear();

                                          }

                                          _scrollDown();
                                        }
                                      },
                                      decoration: InputDecoration(
                                          counterStyle: TextStyle(color: Colors.white),
                                          isDense: true,
                                          hintStyle: TextStyle(color: Colors.white),
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          hintText: 'send message',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              var delete=messageslist.length+1;
                                              print('listlength'+messageslist.length.toString());
                                              if (sendcontroller.text.isNotEmpty) {
                                                messages!.add({
                                                  'message': sendcontroller.text,
                                                  'createdAt': DateTime.now(),
                                                  'email': email,
                                                  'delete':delete
                                                });
                                                messagesrecives!.add({
                                                  'message': sendcontroller.text,
                                                  'createdAt': DateTime.now(),
                                                  'email': email,
                                                  'delete':delete
                                                });
                                                if (auth_controller.boxcheck.read('boxcheck')==true) {
                                                  FirebaseFirestore.instance
                                                      .collection('user').doc(id).get().then((value) {
                                                    print('hellllllo'+value['name']);
                                                    getdatahome(sendcontroller.text,value['name'].toString(),widget.image.toString(),id,widget.tokken);
                                                    FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind').doc(widget.docid).update({
                                                      'lastmessage':sendcontroller.text,
                                                      'timenow':DateTime.now(),
                                                      "numberofmessage":0,


                                                    });
                                                    FirebaseFirestore.instance.collection('user').doc(widget.docid).collection('freind').doc(auth_controller.boxcheckid.read('boxcheckid')).update({
                                                      'lastmessage':sendcontroller.text,
                                                      'timenow':DateTime.now(),
                                                      "numberofmessage":1,

                                                    });
                                                    sendcontroller.clear();


                                                  });
                                                } else {
                                                  getdatahome(sendcontroller.text,auth_controller.boxnamegoogle.read('boxnamegoogle'),widget.image.toString(),id,widget.tokken);
                                                  FirebaseFirestore.instance.collection('user').doc(auth_controller.boxcheckid.read('boxcheckid')).collection('freind').doc(widget.docid).update({
                                                    'lastmessage':sendcontroller.text,
                                                    'timenow':DateTime.now(),
                                                    "numberofmessage":0,

                                                  });
                                                  FirebaseFirestore.instance.collection('user').doc(widget.docid).collection('freind').doc(auth_controller.boxcheckid.read('boxcheckid')).update({
                                                    'lastmessage':sendcontroller.text,
                                                    'timenow':DateTime.now(),
                                                    "numberofmessage":1,



                                                  });
                                                  sendcontroller.clear();


                                                }
                                                print('saddenss'+sendcontroller.text);
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();

                                                _scrollDown();

                                              }
                                            },
                                            icon: Icon(
                                              Icons.send,
                                              color: Color(0xff4d67ee),
                                            ),
                                          )),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            );
          }else{
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Image.asset('images/wifi.png',height: 200,color: Colors.grey,),
                Center(
                  child: Text(
                    'No Internet Please Connection to Your Network ',style: TextStyle(
                      color: Colors.white
                  ),
                  ),
                ),
              ],
            );
          }

        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),

      ),
    );
  }
}
