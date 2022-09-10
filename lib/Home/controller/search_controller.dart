import 'package:get/get.dart';

class Search_Controller extends GetxController{
  String search='';
  addsearch(value){
    search=value;
    update();
  }
}