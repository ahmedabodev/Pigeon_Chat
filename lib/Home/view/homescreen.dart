import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Home/controller/follow_controller.dart';
import 'package:firebase_testing/Home/controller/search_controller.dart';
import 'package:firebase_testing/Home/model/home.dart';
import 'package:firebase_testing/chat/model/message.dart';
import 'package:firebase_testing/chat/view/chatscreen.dart';
import 'package:firebase_testing/const.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Auth_Controller _auth_controller = Get.put(Auth_Controller());
  final Follow_Controller follow_controller = Get.put(Follow_Controller());
  final Search_Controller search_controller = Get.put(Search_Controller());
  CollectionReference user = FirebaseFirestore.instance.collection('user');
  final GetUser_Controller getUser_Controller=Get.put(GetUser_Controller());
  TextEditingController searchcontroller = TextEditingController();

  CollectionReference? message;
  @override
  Widget build(BuildContext context) {
    follow_controller.getdata();
    getUser_Controller.getdata();
    return Scaffold(
      backgroundColor: const Color(0xff061328),
      body: GetBuilder<Search_Controller>(builder: ( controller) {
        return StreamBuilder<QuerySnapshot>(
          stream: user.where('name',isGreaterThanOrEqualTo:
            controller.search,

          ).snapshots(),

          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Home> userlist = [];
              for (int x = 0; x < snapshot.data!.docs.length; x++) {
                userlist.add(Home.fromJson(snapshot.data!.docs[x]));
              }
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 10, right: 10, top: 5),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: searchcontroller,
                              onChanged: (value){
                                controller.addsearch(value);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pls Enter you Email';
                                }
                              },


                              decoration: InputDecoration(
                                  counterStyle: TextStyle(color: Colors.white),
                                  isDense: true,
                                  hintStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.search)

                              ),
                            ),
                          ))
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                        itemCount: userlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          print('myfollow' + userlist[index].followers.toString());

                          return (userlist.isEmpty)
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : (_auth_controller.boxemail.read('boxemail') ==
                              userlist[index].email.toString() ||
                              _auth_controller.boxemailgoogle
                                  .read('boxemailgoogle') ==
                                  userlist[index].email.toString())
                              ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                              : Padding(
                            padding:
                            const EdgeInsets.only(bottom: 5.0),
                            child: Card(
                              elevation: 10,
                              color: const Color(0xff0b1b38),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ((userlist[index]
                                                  .photo
                                                  .toString() ==
                                                  'null'))
                                                  ? const CircleAvatar(
                                                backgroundImage:
                                                AssetImage(
                                                  'images/profile.png',
                                                ),
                                                backgroundColor:
                                                Colors
                                                    .black,
                                                radius: 30,
                                              )
                                                  : CircleAvatar(
                                                backgroundImage:
                                                NetworkImage(userlist[
                                                index]
                                                    .photo
                                                    .toString()),
                                                radius: 30,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      userlist[index]
                                                          .name
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    const SizedBox(height: 5,),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          userlist[index]
                                                              .followers.length
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        const SizedBox(width: 5,),
                                                        Text(
                                                          'Followers',
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GetBuilder<
                                                Follow_Controller>(
                                              builder:
                                                  (controller) {
                                                return (controller.Follwing.contains(snapshot.data!.docs[index].id) == true)
                                                    ? OutlinedButton(
                                                  onPressed:
                                                      () {
                                                    String
                                                    idgoogle =
                                                    auth_controller.boxidgoogle.read('boxidgoogle');

                                                    String id = FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid;
                                                    if (auth_controller.boxcheck.read('boxcheck') ==
                                                        true) {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .collection('freind')
                                                          .doc(id)
                                                          .delete();
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(id)
                                                          .collection('freind')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .delete();
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(id)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayRemove([
                                                          snapshot.data!.docs[index].reference.id
                                                        ])
                                                      });

                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayRemove([
                                                          id
                                                        ])
                                                      });
                                                    } else {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .collection('freind')
                                                          .doc(idgoogle)
                                                          .delete();
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(idgoogle)
                                                          .collection('freind')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .delete();
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(idgoogle)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayRemove([
                                                          snapshot.data!.docs[index].reference.id
                                                        ])
                                                      });

                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayRemove([
                                                          idgoogle
                                                        ])
                                                      });
                                                    }
                                                    controller
                                                        .getdata();
                                                  },
                                                  child: Text(
                                                      'Unfollow'),
                                                )
                                                    : OutlinedButton(
                                                  onPressed:
                                                      () async {
                                                    var myname='hello';
                                                    var myphotoo='null';
                                                    String
                                                    idgoogle =
                                                    auth_controller.boxidgoogle.read('boxidgoogle');
                                                    String id = FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid;

                                                    if (auth_controller.boxcheck.read('boxcheck') ==
                                                        true) {
                                                      FirebaseFirestore.instance.collection('user').doc(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid).get().then((value) {
                                                        myname=value['name'];
                                                        myphotoo=value['photo'];
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(snapshot.data!.docs[index].reference.id)
                                                            .collection('freind')
                                                            .doc(id)
                                                            .set({
                                                          'name':
                                                          myname,
                                                          'email':
                                                          FirebaseAuth.instance.currentUser!.email,
                                                          'photo':
                                                          myphotoo,
                                                          'token':
                                                          mytoken,
                                                          "timenow":
                                                          DateTime.now(),
                                                          'lastmessage':
                                                          '',
                                                          "followers":
                                                          [],
                                                          "numberofmessage":0,

                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(id)
                                                            .collection('freind')
                                                            .doc(snapshot.data!.docs[index].reference.id)
                                                            .set({
                                                          'name':
                                                          userlist[index].name,
                                                          'email':
                                                          userlist[index].email,
                                                          'photo':
                                                          userlist[index].photo,
                                                          'token':
                                                          userlist[index].token,
                                                          "timenow":
                                                          DateTime.now(),
                                                          'lastmessage':
                                                          '',
                                                          "followers":
                                                          [
                                                            snapshot.data!.docs[index].reference.id
                                                          ],
                                                          "numberofmessage":0,

                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(id)
                                                            .update({
                                                          "followers":
                                                          FieldValue.arrayUnion([
                                                            snapshot.data!.docs[index].reference.id
                                                          ])
                                                        });

                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('user')
                                                            .doc(snapshot.data!.docs[index].reference.id)
                                                            .update({
                                                          "followers":
                                                          FieldValue.arrayUnion([
                                                            id
                                                          ])
                                                        });
                                                        controller.getupdate();

                                                        print('mytesttting is'+myphotoo+myname);

                                                      });

                                                    } else {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .collection('freind')
                                                          .doc(idgoogle)
                                                          .set({
                                                        'name':
                                                        _auth_controller.boxnamegoogle.read('boxnamegoogle'),
                                                        'email':
                                                        _auth_controller.boxnamegoogle.read('boxnamegoogle'),
                                                        'photo':
                                                        _auth_controller.boxphoto.read('boxphoto'),
                                                        'token':
                                                        mytoken,
                                                        "timenow":
                                                        DateTime.now(),
                                                        'lastmessage':
                                                        '',
                                                        "followers":
                                                        FieldValue.arrayUnion([]),
                                                        "numberofmessage":0,
                                                      });
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(idgoogle)
                                                          .collection('freind')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .set({
                                                        'name':
                                                        userlist[index].name,
                                                        'email':
                                                        userlist[index].email,
                                                        'photo':
                                                        userlist[index].photo,
                                                        'token':
                                                        userlist[index].token,
                                                        "timenow":
                                                        DateTime.now(),
                                                        'lastmessage':
                                                        '',
                                                        "followers":
                                                        [
                                                          snapshot.data!.docs[index].reference.id
                                                        ],
                                                        "numberofmessage":0,
                                                      });
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(idgoogle)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayUnion([
                                                          snapshot.data!.docs[index].reference.id
                                                        ])
                                                      });

                                                      FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(snapshot.data!.docs[index].reference.id)
                                                          .update({
                                                        "followers":
                                                        FieldValue.arrayUnion([
                                                          idgoogle
                                                        ])
                                                      });
                                                      controller.getupdate();
                                                    }


                                                  },
                                                  child: Text(
                                                      'Follow'),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },),
    );
  }
}
