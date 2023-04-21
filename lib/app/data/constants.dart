import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// String apiUrl = "http://10.0.2.2:5000/api";

// String apiUrl = "http://localhost:5000/api";

String apiUrl = "http://ec2-44-214-226-148.compute-1.amazonaws.com/api";




RxString privilage = "".obs;

class Constants{
  void size(BuildContext context) {

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
  }
}