import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatelessWidget {
  final GetUser_Controller getUser_Controller=Get.put(GetUser_Controller());
  String? docid;
  String? likecounts;
   CollectionReference? comments;
   TextEditingController sendcomentcontroller=TextEditingController();
List<dynamic>comment=[];
  @override
  Widget build(BuildContext context) {
    getUser_Controller.getdata();

    comments=FirebaseFirestore.instance.collection('post').doc(docid).collection('comments');
    return Scaffold(
      backgroundColor:const Color(0xff06142b),
appBar: AppBar(
  backgroundColor:const Color(0xff06142b),

),
      body:OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          final bool connected = connectivity!= ConnectivityResult.none;
          if(connected){
            return  StreamBuilder(
              stream:comments!.orderBy('Time',descending: false).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  comment.clear();
                  for(int x=0;x<snapshot.data!.docs.length;x++){
                    comment.add(snapshot.data.docs[x]);

                  }

                  return  Column(
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width:10 ,),
                          InkWell(
                            onTap: (){
                            },
                            child: Row(
                              children: [
                                Icon(Icons.favorite,color: Colors.red,),
                                const SizedBox(width: 6,),
                                Text(likecounts.toString(),style: TextStyle(
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
                      const SizedBox(height: 10,),
                      (comment.isEmpty)?Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20,),

                                Image.asset('images/chat (2).png',color: Colors.grey,height: 200,),
                                const SizedBox(height: 10,),

                                Text('NO Commnet Yet',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20
                                ),),
                                const SizedBox(height: 5,),
                                Text('Be The First to Comment.',style: TextStyle(
                                    color: Colors.white
                                ),),
                                const SizedBox(height: 20,),

                              ],
                            ),
                          ),
                        ),
                      ):Expanded(child: ListView.builder(
                        itemCount: comment.length,
                        itemBuilder: (BuildContext context, int index) {

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (comment[index]['photo']=='null')?const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:AssetImage('images/profile.png',) ,
                                  backgroundColor: Colors.black,
                                ):CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(comment[index]['photo']),
                                ),
                                const SizedBox(width: 5,),
                                Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  color: Color(0xff2077ff),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(comment[index]['name'].toString(),style: TextStyle(
                                            color: Colors.white
                                        ),),
                                        const SizedBox(height: 5,),

                                        Text(comment[index]['comment'],style: TextStyle(
                                            color: Colors.white
                                        ),),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );




                        },),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        // color: Color(0xff10192b),
                        child: Column(
                          children: [
                            Divider(
                              color:Colors.grey,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                (getUser_Controller.photo=='null')?const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:AssetImage('images/profile.png') ,
                                  backgroundColor: Colors.black,
                                ):CircleAvatar(
                                  radius: 20,
                                  backgroundImage:NetworkImage(getUser_Controller.photo.toString()) ,
                                ),
                                const SizedBox(width: 5,),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0, left: 10, right: 10, top: 0),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        controller: sendcomentcontroller,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'pls Enter you comment';
                                          }
                                        },

                                        decoration: InputDecoration(
                                            counterStyle: TextStyle(color: Colors.white),
                                            hintStyle: TextStyle(color: Colors.white),
                                            contentPadding: EdgeInsets.all(0),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius: BorderRadius.circular(20)),
                                            hintText: 'Write a comment',
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance.collection('post').doc(docid).collection('comments').add({
                                                  "name":getUser_Controller.name,
                                                  "photo":getUser_Controller.photo,
                                                  "comment":sendcomentcontroller.text,
                                                  "Time":DateTime.now(),
                                                });
                                                FirebaseFirestore.instance.collection('post').doc(docid).update({
                                                  "Comments":FieldValue.arrayUnion([
                                                    DateTime.now()
                                                  ])
                                                });
                                                sendcomentcontroller.clear();
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
                            const SizedBox(height: 8,)
                          ],
                        ),
                      ),

                    ],
                  );
                }
                else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }


              },);
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

   CommentsScreen({
     this.docid,
     this.likecounts,
   });
}
