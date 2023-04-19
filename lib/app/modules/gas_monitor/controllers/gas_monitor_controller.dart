import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/constants.dart';
import '../../home/ModelGasMonitorData.dart';

class GasMonitorController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchBranches().whenComplete(() => fetchGases().whenComplete(() => fetchVendor().whenComplete(() => fetchManifold().whenComplete(() => getGasStatus()))));
  }

  var selectedBranchId = 0.obs;
  var isLoading = false.obs;
  var branchData = [].obs;

  var selectedGasId = 0.obs;
  var gasData = [].obs;

  var onlineGasMonitorData = <GasMonitor>[].obs;
  var standbyGasMonitorData = <GasMonitor>[].obs;
  var stockGasMonitorData = <GasMonitor>[].obs;
  var bottomNavigationIndex = 0.obs;

  var manifoldData = [].obs;
  var selectedManifoldId = 0.obs;

  var vendorData = [].obs;
  var selectedVendorId = 0.obs;

  var gasStatus = [].obs;
  var selectedGasStatus = 0.obs;

  final addSerialNoController = TextEditingController();
  final addConsumptionNoController = TextEditingController();
  final addGasQtyNoController = TextEditingController();
  final addOperatorNameController = TextEditingController();

  final updateSerialNoController = TextEditingController();
  final updateConsumptionNoController = TextEditingController();
  final updateGasQtyNoController = TextEditingController();
  final updateOperatorNameController = TextEditingController();



  Future<void> fetchGases() async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await http.get(Uri.parse("$apiUrl/get_gases"), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      gasData.value = data;
      isLoading.value = false;
    }
  }

  Future<List> fetchBranches() async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.get(Uri.parse('$apiUrl/branches'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      branchData.value = jsonDecode(response.body);
      print(branchData);
      isLoading.value = false;
      return branchData;
    } else {
      isLoading.value = false;
      throw Exception('Failed to load branches');
    }
  }

  void fetchGasMonitorData(int branchId, int gasId) async {
    print(branchId);
    print(gasId);
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await http.get(Uri.parse("$apiUrl/get_gas_monitor?branch_id=$branchId&gases_id=$gasId") ,
        headers: {
          'Authorization':'Bearer $token'
        });
    print(response.body);
    if(response.statusCode == 200){

      var data  = ModelGasMonitor.fromJson(jsonDecode(response.body));
      onlineGasMonitorData.value = data.onlineGasMonitors ?? [];
      standbyGasMonitorData.value = data.standbyGasMonitors ?? [];
      stockGasMonitorData.value = data.stockGasMonitors ?? [];

    }
    else {
      throw Exception();
    }
  }

  Future<void> getGasStatus() async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await http.get(Uri.parse("$apiUrl/get_gas_status"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      gasStatus.value = jsonDecode(response.body);
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }
  Future<void> fetchManifold() async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await http.get(Uri.parse("$apiUrl/get_gas_manifold"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      manifoldData.value = jsonDecode(response.body);
      isLoading.value = false;
    } else {
      isLoading.value = false;
    }
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


  void clearData(){
    addSerialNoController.clear();
    addConsumptionNoController.clear();
    addGasQtyNoController.clear();
    addOperatorNameController.clear();
    updateSerialNoController.clear();
    updateConsumptionNoController.clear();
    updateGasQtyNoController.clear();
    updateOperatorNameController.clear();
  }


  Future<void> addGasMonitorData() async {

    if (addGasQtyNoController.text == "") {
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
      var response = await http.post(Uri.parse("$apiUrl/add_gas_monitor"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
              <String, String>{
                "branch_id":selectedBranchId.value.toString(),
                "gases_id":selectedGasId.value.toString(),
                "manifold_id":selectedManifoldId.value.toString(),
                "status_id":selectedGasStatus.value.toString(),
                "vendor_id":selectedVendorId.value.toString(),
                "serial_no":addSerialNoController.text,
                "consumption":addConsumptionNoController.text,
                "operator_name":addOperatorNameController.text,
                "gas_Qty":addGasQtyNoController.text
              }));
      print(response.body);
      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Added Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        clearData();
        isLoading.value = false;
        fetchGasMonitorData(selectedBranchId.value , selectedGasId.value);

      } else {
        Fluttertoast.showToast(
            msg: "Cannot Add",
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
  Future<void> updateGasMonitorData(int id , String serialNo,String consumption, String operatorName ,String gasQty , int branchId , int gasId , int statusId , int vendorId ,int manifoldId ) async {

      isLoading.value = true;
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      var response = await http.put(Uri.parse("$apiUrl/update_gas_monitor/$id"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonEncode(
              <String, dynamic>{
                "branch_id":(selectedBranchId.value == 0)?branchId :selectedBranchId.value.toString(),
                "gases_id":(selectedGasId.value ==0)?gasId :selectedGasId.value.toString(),
                "manifold_id":(selectedManifoldId.value ==0)?manifoldId :selectedManifoldId.value.toString(),
                "status_id":(selectedGasStatus.value ==0)?statusId :selectedGasStatus.value.toString(),
                "vendor_id":(selectedVendorId.value ==0)?vendorId :selectedVendorId.value.toString(),
                "serial_no":(updateSerialNoController.text == "")?serialNo:updateSerialNoController.text,
                "consumption":(updateConsumptionNoController.text == "")? consumption:updateConsumptionNoController.text,
                "operator_name":(updateOperatorNameController.text == "")?operatorName :updateOperatorNameController.text,
                "gas_Qty":(updateGasQtyNoController.text == "")?gasQty :updateGasQtyNoController.text,
              }));
      print(response.body);
      if (response.statusCode == 200) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        clearData();
        isLoading.value = false;
        fetchGasMonitorData(selectedBranchId.value , selectedGasId.value);

      } else {
        Fluttertoast.showToast(
            msg: "Cannot Add",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        isLoading.value = false;
      }

  }

  Future<void> deleteGasMonitorData(int id) async {
    isLoading.value = true;
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.delete(
      Uri.parse("$apiUrl/delete_gas_monitor/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      Get.back();

      Fluttertoast.showToast(
          msg: "Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      fetchGasMonitorData(selectedBranchId.value , selectedGasId.value);
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
