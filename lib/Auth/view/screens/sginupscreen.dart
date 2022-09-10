import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_testing/Auth/controller/google_controller.dart';
import 'package:firebase_testing/Auth/view/screens/loginscreen.dart';
import 'package:firebase_testing/Auth/view/widget/imagepicker.dart';
import 'package:firebase_testing/chat/view/chatscreen.dart';
import 'package:firebase_testing/const.dart';
import 'package:firebase_testing/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widget/text form field passward.dart';

class SignScreen extends StatelessWidget {
  SignScreen({Key? key}) : super(key: key);
  final Auth_Controller _auth_controller =Get.put(Auth_Controller());

  TextEditingController emailcontroller =TextEditingController();
  TextEditingController namecontroller =TextEditingController();
  TextEditingController passwordcontroller =TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff06142b),

      body: Form(
        key:_formKey ,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration:const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('images/background.jpg'),
          //       fit: BoxFit.cover,
          //
          //     )
          // ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: Card(
                      elevation: 10,
                      color: Colors.black26.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                        child: Column(

                          children: [
                            const SizedBox(height: 10,),

                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'pls Enter you Name';
                                }
                              },
                              controller: namecontroller,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  hintText: 'Name',
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'pls Enter you Email';
                                }
                              },
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  hintText: 'Email',
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                            ),
                            const SizedBox(height: 20,),

                            Textformfieldpassward(
                              controller: passwordcontroller,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'pls Enter you Email';
                                }
                              },
                              obscureText: true,
                              hintText: 'Password',
                            ),
                            const SizedBox(height: 20,),
                            CameraScreen(),
                            const SizedBox(height: 20,),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              height: 40,
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  
                                  _auth_controller.CreateUserWithEmailAndPassword(

                                      email: emailcontroller.text,
                                      password: passwordcontroller.text,
                                    username: namecontroller.text,
                                    linkphoto: photo.toString()
                                  );
                                  print('myphottttttt'+photo.toString());
                                }
                              },
                              color: Color(0XFF02c38e),
                              child:const Text('Register',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),),

                            ),
                            const SizedBox(height: 10,),
                            Text('or',style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                            const SizedBox(height: 10,),
                            Row(
                              children:  [
                                const Text(' have account?',style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),),
                                TextButton(onPressed: (){
                                  Get.offAll(()=>LoginScreens());
                                }, child:const Text('Sign in',style:  TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),),
                                )

                              ],
                            )



                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
