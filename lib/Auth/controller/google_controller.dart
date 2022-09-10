import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Home/model/home.dart';
import 'package:firebase_testing/Home/view/homescreen.dart';
import 'package:firebase_testing/const.dart';
import 'package:firebase_testing/main.dart';
import 'package:firebase_testing/mainscreen/view/mainscreen.dart';
import 'package:firebase_testing/post/controller/getuser_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Auth_Controller extends GetxController{

final FirebaseAuth firebaseAuth=FirebaseAuth.instance ;
User? get currentUser=>firebaseAuth.currentUser;
Stream<User?>  get authStateChanges=>firebaseAuth.authStateChanges();
CollectionReference user = FirebaseFirestore.instance.collection('user');
bool check=false;
final boxemail = GetStorage();
final boxemailgoogle = GetStorage();
final boxidgoogle = GetStorage();
final boxname = GetStorage();
final boxnamegoogle = GetStorage();
final boxcheck = GetStorage();
final boxcheckid = GetStorage();
final boxphoto = GetStorage();

Future<void>CreateUserWithEmailAndPassword(
{
  required String email,
  required String password,
  required String username,
  required String linkphoto,
}
    ) async{
// Get a non-default Storage bucket
  firebaseAuth.createUserWithEmailAndPassword(
      email:email,
      password: password).catchError((e){
    if (e.code == 'weak-password') {
      Fluttertoast.showToast(
          msg: 'The password provided is too weak.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff2077ff),
          textColor: Colors.white,
          fontSize: 16.0
      );
      Get.defaultDialog(title: 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(
          msg: 'The account already exists for that email.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff2077ff),
          textColor: Colors.white,
          fontSize: 16.0
      );

  }else if(e.code=='invalid-email'){

      Fluttertoast.showToast(
          msg: 'invalid-email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff2077ff),
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

      }).then((value) {

    Fluttertoast.showToast(
        msg: 'Register  Succeed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff2077ff),
        textColor: Colors.white,
        fontSize: 16.0
    );
    Get.offAll(LoginScreens());

    String id=value.user!.uid;
       FirebaseFirestore.instance.collection('user').doc(id).set(
        {
          'name':username,
          'email':email,
          'photo':linkphoto,
          'token':mytoken,
          'showmessage':false,
          'followers':[

          ],
        });



  });



}

Future<void>signInWithEmailandPassword(
{
  required String email,
  required String password
}
    ) async{

    firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((e){
          print(e.code);
      if(e.code=='user-not-found'){
        Fluttertoast.showToast(
            msg: "user not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xff2077ff),
            textColor: Colors.white,
            fontSize: 16.0
        );

      }else if (e.code=='wrong-password'){
        Fluttertoast.showToast(
            msg: 'wrong-password',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xff2077ff),
            textColor: Colors.white,
            fontSize: 16.0
        );


      }else if(e.code=='invalid-email'){

        Fluttertoast.showToast(
            msg: 'invalid-email',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xff2077ff),
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }).then((value){
      boxemail.write('boxemail', value.user!.email) ;
      boxcheck.write('boxcheck',true);
      boxname.write('boxname', value.user!.displayName.toString());
      boxcheckid.write('boxcheckid', value.user!.uid);
      FirebaseFirestore.instance.collection('user').doc(value.user!.uid).update(
          {
            'token':mytoken,
          });
      update();
      Fluttertoast.showToast(
          msg: 'Login Succeed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xff2077ff),
          textColor: Colors.white,
          fontSize: 16.0
      );

      Get.offAll(()=>MainScreen());
    });
  }



  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,

    );
    print('myname '+googleUser!.email.toString());
    print('myname '+googleUser.photoUrl.toString());
    print('myname '+googleUser.displayName.toString());
    boxemailgoogle.write('boxemailgoogle', googleUser.email.toString());
    boxphoto.write('boxphoto', googleUser.photoUrl.toString());
    // print(snapshot.data!.docs[0]['message']);
    List<Home>userlist=[];

    var id= googleUser.id;
    boxidgoogle.write('boxidgoogle', googleUser.id);
    boxcheckid.write('boxcheckid', googleUser.id);
    update();

    print('mytokemishere'+googleAuth!.idToken.toString());

    CollectionReference user1 = FirebaseFirestore.instance.collection('user');
    boxcheck.write('boxcheck',false);
    boxnamegoogle.write('boxnamegoogle', googleUser.displayName);
    FirebaseFirestore.instance.collection('user').doc(googleUser.id).update(
        {
          'token':mytoken,
        });
    user1.get().then((value) {
      value.docs.forEach((element) {

      userlist.add(Home.fromJson(element.data()));

    }


    );


      print('id');

for(int x=0 ;x<userlist.length;x++){
  if(userlist[x].email.toString()==googleUser.email.toString()){
    print('hello ahmed'+userlist[x].email.toString());
    check=true;
  }
  else{
  }
}

if(check==true){

}
else{
print('testingsigin'+check.toString());
  FirebaseFirestore.instance.collection('user').doc(id).set(
      {
        'name':googleUser.displayName,
        'email':googleUser.email,
        'photo':googleUser.photoUrl,
        'token':mytoken,
        'showmessage':false,
        'followers':[

        ],}    );
}

    });



    Fluttertoast.showToast(
        msg: 'Login Succeed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff2077ff),
        textColor: Colors.white,
        fontSize: 16.0
    );

    Get.offAll(()=>MainScreen());
    check=false;
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<void> signOut() async {

    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(
        msg: 'Signout Succeed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff2077ff),
        textColor: Colors.white,
        fontSize: 16.0
    );
    Get.offAll(()=>LoginScreens());


  }


}