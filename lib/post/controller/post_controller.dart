import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:firebase_testing/post/model/commentsmodel.dart';
import 'package:firebase_testing/post/model/postmodel.dart';
import 'package:get/get.dart';

class Post_Controller extends GetxController{
  Post_Controller(){
    getdata();
  }
  getupdata(){
    post.clear();
    getdata();
    update();

  }
  // List<postmodel> post = <postmodel>[].obs;
List<postmodel>post=[];
List<String>postid=[];
List<int>countcomment=[];
List<dynamic>comments=[];
  void getdata(){
    CollectionReference user= FirebaseFirestore.instance.collection('post');
    user.snapshots().forEach((element) {
      element.docs.forEach((element) {
        post.add(postmodel.fromJson(element.data()));
        print('mypostesis'+post.toString());

      });
      // post.add(postmodel.fromJson(element.docs));
    });
    update();
    // if(post.isEmpty) {
    //   FirebaseFirestore.instance.collection('post').orderBy('Time',descending: true).get().then((value){
    //   print(value.docs);
    //   for(var element in value.docs){
    //     postid.add(element.id);
    //     post.add(postmodel.fromJson(element.data()));
    //     }
    //     print(post.length);
    //     update();
    //
    //   }
    //
    //  );
    // }
  }
  void getcomment(String postiq){


      FirebaseFirestore.instance.collection('post').doc(postiq).collection('comments').get().then((value) {
        // comments.add(commentsmodel.forJson(value.docs));
        countcomment.add(value.docs.length);
        // comments.add(value.docs);
        print('mycomements'+countcomment.toString());

      });





  }

}