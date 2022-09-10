import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:firebase_testing/post/controller/post_controller.dart';
import 'package:firebase_testing/post/model/postmodel.dart';
import 'package:firebase_testing/post/view/comments/commetsscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'postimage/postiamgescreen.dart';
enum Menu { itemOne, itemTwo, itemThree, itemFour }

class PostScreen extends StatefulWidget {
   PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final GetUser_Controller getUser_Controller=Get.put(GetUser_Controller());


   CollectionReference? user;
  @override
  Widget build(BuildContext context) {
    user= FirebaseFirestore.instance.collection('post');
    List<postmodel>post=[];
    List<dynamic>Likes=[];
    getUser_Controller.getdata();
    return Scaffold(
      backgroundColor:const Color(0xff06142b),

      body: StreamBuilder(
        stream: user!.orderBy('Time',descending:true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            post.clear();

            for(int x=0;x<snapshot.data!.docs.length;x++){
              //8
              post.add(postmodel.fromJson(snapshot.data!.docs[x]));
              Likes.add(snapshot.data!.docs[x]);

              print('myliast'+snapshot.data.docs[x].reference.id.toString());
            }

            return  ListView.builder(
              itemCount: post.length,
              itemBuilder: (BuildContext context, int index) {
                DateTime timeofnow= DateTime.now();
                String Today=DateFormat('yyyy-MM-dd').format(timeofnow);
                DateTime mytime=DateTime.parse(post[index].Time.toDate().toString());
                String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(mytime);
                String formattedDatetody = DateFormat('HH:mm').format(mytime);
                String formattedDateyear = DateFormat('yyyy-MM-dd').format(mytime);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    color: const Color(0xff0b1b38),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Expanded(
                             child: Row(
                               children: [
                                 (post[index].photo.toString()=='null')?const CircleAvatar(
                                   radius: 20,
                                   backgroundImage:AssetImage('images/profile.png') ,
                                   backgroundColor: Colors.black,
                                 ):CircleAvatar(
                                   radius: 20,
                                   backgroundImage: NetworkImage(post[index].photo.toString()),
                                 ),
                                 const SizedBox(width: 10,),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Text(post[index].name.toString(),style: TextStyle(
                                         color: Colors.white
                                     ),),
                                     (Today==formattedDateyear)?Text(formattedDatetody,style: TextStyle(
                                         color: Colors.grey
                                     ),):Text(formattedDate,style: TextStyle(
                                         color: Colors.grey
                                     ),),
                                   ],
                                 ),
                               ],
                             ),
                           ),

                              GetBuilder<GetUser_Controller>(builder: ( controller) {
                                return (post[index].email.toString()==controller.email.toString())?PopupMenuButton<Menu>(
                                    icon: Icon(Icons.adaptive.more,color: Colors.white,),
                                    // color: Colors.indigo,
                                    color: const Color(0xff061328),
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)

                                    ),

                                    // Callback that sets the selected popup menu item.
                                    onSelected: (Menu item) {
                                      setState(() {
                                        if(item.name.toString()=="itemOne"){
                                          showDialog(context: context, builder: (BuildContext context) {
                                            return  AlertDialog(
                                              elevation: 10,

                                              backgroundColor: const Color(0xff06142b),
                                              title: Column(
                                                children: [
                                                  const Text('Do you want Delete this post ?',style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),),
                                                  const SizedBox(height: 10,),
                                                  Wrap(
                                                    children: [
                                                      OutlinedButton(

                                                        onPressed: (){
                                                          FirebaseFirestore.instance.collection('post').doc(snapshot.data.docs[index].reference.id.toString()).delete();
                                                          Get.back();
                                                        },
                                                        child:const Text('Yes',style: TextStyle(
                                                          fontSize: 14,
                                                        ),),

                                                      ),
                                                      const SizedBox(width: 10,),
                                                      OutlinedButton(onPressed: (){
                                                        Get.back();
                                                      },
                                                        child: const Text('No',style: TextStyle(
                                                          fontSize: 14,
                                                        ),),

                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },);
                                        }
                                      });
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[

                                     const  PopupMenuItem<Menu>(
                                        value: Menu.itemOne,
                                        child: Text('Delete',style: TextStyle(
                                          color: Colors.white
                                        ),),
                                      ),
                                      const PopupMenuItem<Menu>(
                                        value: Menu.itemTwo,
                                        child: Text('Cancel',style: TextStyle(
                                            color: Colors.white
                                        )),
                                      ),

                                    ]):SizedBox();

                              }, ),

                            ],
                          ),
                          const SizedBox(height: 10,),

                          Text(post[index].mypost.toString(),style: TextStyle(
                              color: Colors.white
                          ),),
                          const SizedBox(height: 5,),

                          if(post[index].postphoto!='null')InkWell(
                            onTap: (){
                              Get.to(()=>PostImageScreen(image:post[index].postphoto.toString() ));
                            },
                            child: Hero(

                              tag: post[index].postphoto.toString(),
                              child:CachedNetworkImage(
                                imageUrl: post[index].postphoto.toString(),
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    Center(child: CircularProgressIndicator(value: downloadProgress.progress,color: Colors.grey,)),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text('${snapshot.data.docs[index]['Likes'].length.toString()} Like',style: TextStyle(
                                  color: Colors.grey
                              ),),

                              InkWell(
                                onTap: (){
                                  Get.to(()=>CommentsScreen(likecounts: snapshot.data.docs[index]['Likes'].length.toString(),docid: snapshot.data!.docs[index].reference.id.toString()));

                                },
                                child: Text('${snapshot.data.docs[index]['Comments'].length.toString()} comment',style: TextStyle(
                                    color: Colors.grey
                                ),),
                              )

                            ],
                          ),

                          Divider(
                            color:Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              (snapshot.data.docs[index]['Likes'].contains(auth_controller.boxcheckid.read('boxcheckid')))?InkWell(
                                onTap: (){
                                  FirebaseFirestore.instance.collection('post').doc( snapshot.data!.docs[index].reference.id.toString()).collection('likes').doc(auth_controller.boxcheckid.read('boxcheckid')).set({
                                    "Like":true
                                  });
                                  FirebaseFirestore.instance.collection('post').doc( snapshot.data!.docs[index].reference.id.toString()).update({
                                    "Likes":FieldValue.arrayRemove([
                                      auth_controller.boxcheckid.read('boxcheckid')
                                    ])
                                  });

                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite,color: Colors.red,),
                                    Text(' Like',style: TextStyle(
                                        color: Colors.red
                                    ),)
                                  ],
                                ),
                              ):InkWell(
                                onTap: (){
                                  FirebaseFirestore.instance.collection('post').doc( snapshot.data!.docs[index].reference.id.toString()).collection('likes').doc(auth_controller.boxcheckid.read('boxcheckid')).set({
                                    "Like":true
                                  });
                                  FirebaseFirestore.instance.collection('post').doc( snapshot.data!.docs[index].reference.id.toString()).update({
                                    "Likes":FieldValue.arrayUnion([
                                      auth_controller.boxcheckid.read('boxcheckid')

                                    ])
                                  });

                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite,color: Colors.grey,),
                                    Text(' Like',style: TextStyle(
                                        color: Colors.grey
                                    ),)
                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: (){
                                  Get.to(()=>CommentsScreen(likecounts: snapshot.data.docs[index]['Likes'].length.toString(),docid: snapshot.data!.docs[index].reference.id.toString()));
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.comment,color: Colors.grey,),
                                    Text(' Comment',style: TextStyle(
                                        color: Colors.grey
                                    ),)
                                  ],
                                ),
                              ),


                            ],
                          ),
                          Divider(
                            color:Colors.grey,
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              },);
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
      },),
    );
  }
}
