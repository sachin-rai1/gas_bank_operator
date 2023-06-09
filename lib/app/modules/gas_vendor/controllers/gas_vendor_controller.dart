import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/constants.dart';

class GasVendorController extends GetxController {
  var isLoading = false.obs;
  var vendorData = [].obs;
  final addVendorNameController = TextEditingController();
  final updateVendorNameController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchVendor();
  }

  Future<void> fetchVendor() async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await http.get(Uri.parse("$apiUrl/get_gas_vendor"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      vendorData.value = jsonDecode(response.body);
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  Future<void> addVendor() async {
    if (addVendorNameController.text == "") {
      Fluttertoast.showToast(
          msg: "Enter Vendor Name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      isLoading.value = true;
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      var response = await http.post(Uri.parse("$apiUrl/add_gas_vendor"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
              <String, String>{"vendor_name": addVendorNameController.text}));
      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Vendor added Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        addVendorNameController.clear();
        isLoading.value = false;
        fetchVendor();

      } else {
        Fluttertoast.showToast(
            msg: "Cannot Add Vendor",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading.value = false;
      }
    }
  }

  Future<void> updateVendor(int id) async {
    if (updateVendorNameController.text == "") {
      Fluttertoast.showToast(
          msg: "Enter Vendor Name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      isLoading.value = true;
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      var response = await http.put(Uri.parse("$apiUrl/update_gas_vendor/$id"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
              <String, String>{"vendor_name": updateVendorNameController.text}));
      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "vendor Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        updateVendorNameController.clear();
        isLoading.value = false;
        fetchVendor();
      } else {
        print(response.body);
        Fluttertoast.showToast(
            msg: "Cannot Update vendor",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteVendor(int id) async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.delete(
      Uri.parse("$apiUrl/delete_gas_vendor/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      Get.back();

      Fluttertoast.showToast(
          msg: "Vendor deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      fetchVendor();
    }
    else{
      Get.back();
      Fluttertoast.showToast(
          msg: "Cannot delete , Please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isLoading.value = false;
    }

  }
}
