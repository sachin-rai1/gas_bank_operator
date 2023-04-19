import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gas_bank_operator/app/modules/login/views/login_view.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/constants.dart';
import '../../../data/widgets.dart';
import '../../branchData/views/branch_data_view.dart';
import '../../gas_manifold/views/gas_manifold_view.dart';
import '../../gas_vendor/views/gas_vendor_view.dart';
import '../../gases/views/gases_view.dart';
import '../controllers/gas_monitor_controller.dart';

class GasMonitorView extends GetView<GasMonitorController> {
  GasMonitorView({Key? key}) : super(key: key);
  final gasMonitorController = Get.put(GasMonitorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: CircleAvatar(
                  radius: w / 5,
                  backgroundColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      "assets/images/cblogo.png",
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                  onTap: () => Get.to(() => GasesView()),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.gas_meter,
                        size: 25,
                        color: Colors.redAccent,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Gases",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                  onTap: () => Get.to(() => GasManifoldView()),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.gas_meter_sharp,
                        color: Colors.teal,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Gas Manifold",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                  onTap: () => Get.to(() => GasVendorView()),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Gas Vendor",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: InkWell(
                  onTap: () => Get.offAll(()=>LoginView()),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.black87,
                        size: 25,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: const Text('GasMonitorView'),
          actions: [
             MaterialButton(
               elevation: 2,
               shape: const CircleBorder(),
               onPressed: (){
                 addGasMonitorData(context);
               },
               child: const Icon(Icons.add_circle ,color: Colors.purpleAccent, size: 50,),
             ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: RefreshIndicator(
            onRefresh: () {
              return Future(
                () => controller.fetchBranches().whenComplete(() =>controller.fetchGases().whenComplete(() =>controller.fetchVendor().whenComplete(() => controller.fetchManifold().whenComplete(() => controller.getGasStatus()))))
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => TextFormWidget(
                          dropDown: true,
                          titleText: "Select Branch",
                          dropDownOnChanged: (value) {
                            log(value.toString());
                          },
                          dropDownWidth: w / 1.6,
                          dropDownItems: controller.branchData.map((branch) {
                            return DropdownMenuItem<String>(
                                value: branch["branch_name"],
                                onTap: () {
                                  controller.selectedBranchId.value =
                                      branch["branch_id"];
                                  controller.fetchGasMonitorData(
                                      controller.selectedBranchId.value,
                                      controller.selectedGasId.value);
                                },
                                child: Text(branch["branch_name"]));
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MaterialButton(
                          onPressed: () {
                            Get.to(() => BranchDataView());
                          },
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add_circle,
                            size: 50,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => TextFormWidget(
                            dropDownOnChanged: (value) {},
                            dropDownItems: controller.gasData.map((gases) {
                              return DropdownMenuItem<String>(
                                onTap: () {
                                  controller.selectedGasId.value =
                                      gases["gases_id"];
                                  controller.fetchGasMonitorData(
                                      controller.selectedBranchId.value,
                                      controller.selectedGasId.value);
                                },
                                value: gases["gases_name"],
                                child: Text(gases["gases_name"]),
                              );
                            }).toList(),
                            dropDown: true,
                            titleText: "Select Gas",
                            dropDownWidth: w / 1.6),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MaterialButton(
                          onPressed: () {
                            Get.to(() => GasesView());
                          },
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.add_circle,
                            size: 50,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => (controller.onlineGasMonitorData.isEmpty)
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.onlineGasMonitorData.length,
                            itemBuilder: (context, index) {
                              var startingDate = DateFormat("dd-MM-yyyy")
                                  .format(DateTime.parse(controller
                                      .onlineGasMonitorData[index].startingOn
                                      .toString()));
                              var dueDate = DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(controller
                                      .onlineGasMonitorData[index].dueDate
                                      .toString()));
                              return Card(
                                color: Colors.greenAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children:  [
                                            InkWell(onTap: (){
                                              updateGasMonitorData(context,
                                                controller.onlineGasMonitorData[index].gasMonitorId!,
                                                controller.onlineGasMonitorData[index].branchName!,
                                                controller.onlineGasMonitorData[index].gasName!,
                                                controller.onlineGasMonitorData[index].statusName!,
                                                controller.onlineGasMonitorData[index].vendorName!,
                                                controller.onlineGasMonitorData[index].manifoldName!,
                                                controller.onlineGasMonitorData[index].serialNo!.toString(),
                                                controller.onlineGasMonitorData[index].consumption!.toString(),
                                                controller.onlineGasMonitorData[index].gasQty!.toString(),
                                                controller.onlineGasMonitorData[index].operatorName!.toString(),
                                                controller.onlineGasMonitorData[index].branchId!,
                                                controller.onlineGasMonitorData[index].gasesId!,
                                                controller.onlineGasMonitorData[index].statusId!,
                                                controller.onlineGasMonitorData[index].vendorId!,
                                                controller.onlineGasMonitorData[index].manifoldId!,
                                              );
                                            }, child: const Icon(Icons.edit_note_outlined , size: 35,color: Colors.deepPurpleAccent,)),
                                            const SizedBox(width: 20,),
                                            InkWell(onTap: (){
                                              deleteGasMonitorData(context, controller.onlineGasMonitorData[index].gasMonitorId!);
                                            }, child: const Icon(Icons.delete_forever_sharp , size: 30, color: Colors.red,)),
                                          ],
                                        ),
                                      ),
                                      const MyTextWidget(
                                        title: "Status",
                                        body: "Online",
                                      ),
                                      MyTextWidget(
                                        title: "Started On",
                                        body: startingDate,
                                      ),
                                      MyTextWidget(
                                        title: "Serial No",
                                        body: controller
                                            .onlineGasMonitorData[index]
                                            .serialNo
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Total Qty",
                                        body: controller
                                            .onlineGasMonitorData[index].gasQty
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Balance Qty",
                                        body: controller
                                            .onlineGasMonitorData[index]
                                            .remainingStock
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Total Days Left",
                                        body: controller
                                            .onlineGasMonitorData[index]
                                            .remainingStockDays
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Last Date",
                                        body: dueDate,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                  Obx(
                    () => (controller.standbyGasMonitorData.isEmpty)
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.standbyGasMonitorData.length,
                            itemBuilder: (context, index) {
                              var startingDate = DateFormat("dd-MM-yyyy")
                                  .format(DateTime.parse(controller
                                      .standbyGasMonitorData[index].startingOn
                                      .toString()));
                              var dueDate = DateFormat("dd-MM-yyyy").format(
                                  DateTime.parse(controller
                                      .standbyGasMonitorData[index].dueDate
                                      .toString()));
                              return Card(
                                color: Colors.yellow,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children:  [
                                            InkWell(onTap: (){
                                              updateGasMonitorData(
                                                  context,
                                                controller.standbyGasMonitorData[index].gasMonitorId! ,
                                                controller.standbyGasMonitorData[index].branchName!,
                                                controller.standbyGasMonitorData[index].gasName!,
                                                controller.standbyGasMonitorData[index].statusName!,
                                                controller.standbyGasMonitorData[index].vendorName!,
                                                controller.standbyGasMonitorData[index].manifoldName!,
                                                controller.standbyGasMonitorData[index].serialNo!.toString(),
                                                controller.standbyGasMonitorData[index].consumption!.toString(),
                                                controller.standbyGasMonitorData[index].gasQty!.toString(),
                                                controller.standbyGasMonitorData[index].operatorName!.toString(),
                                                controller.standbyGasMonitorData[index].branchId!,
                                                controller.standbyGasMonitorData[index].gasesId!,
                                                controller.standbyGasMonitorData[index].statusId!,
                                                controller.standbyGasMonitorData[index].vendorId!,
                                                controller.standbyGasMonitorData[index].manifoldId!,
                                              );
                                            }, child: const Icon(Icons.edit_note_outlined , size: 35,color: Colors.deepPurpleAccent,)),
                                            const SizedBox(width: 20,),
                                            InkWell(onTap: (){
                                              deleteGasMonitorData(context, controller.standbyGasMonitorData[index].gasMonitorId!);
                                            }, child: const Icon(Icons.delete_forever_sharp , size: 30, color: Colors.red,)),
                                          ],
                                        ),
                                      ),
                                      const MyTextWidget(
                                        title: "Status",
                                        body: "Stand By",
                                      ),
                                      MyTextWidget(
                                        title: "Starting On",
                                        body: startingDate,
                                      ),
                                      MyTextWidget(
                                        title: "Serial No",
                                        body: controller
                                            .standbyGasMonitorData[index]
                                            .serialNo
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Total Qty",
                                        body: controller
                                            .standbyGasMonitorData[index].gasQty
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Balance Qty",
                                        body: controller
                                            .standbyGasMonitorData[index]
                                            .remainingStock
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Total Days Left",
                                        body: controller
                                            .standbyGasMonitorData[index]
                                            .remainingStockDays
                                            .toString(),
                                      ),
                                      MyTextWidget(
                                        title: "Last Date",
                                        body: dueDate,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                  Obx(
                    () => (controller.stockGasMonitorData.isEmpty)
                        ? Container()
                        : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.stockGasMonitorData.length,
                              itemBuilder: (context, index) {
                                var startingDate = DateFormat("dd-MM-yyyy")
                                    .format(DateTime.parse(controller
                                        .stockGasMonitorData[index].startingOn
                                        .toString()));
                                var dueDate = DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(controller
                                        .stockGasMonitorData[index].dueDate
                                        .toString()));

                                return Card(
                                  color: Colors.cyan,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children:  [
                                              InkWell(onTap: (){
                                                updateGasMonitorData(
                                                    context,
                                                  controller.stockGasMonitorData[index].gasMonitorId!,
                                                  controller.stockGasMonitorData[index].branchName!,
                                                  controller.stockGasMonitorData[index].gasName!,
                                                  controller.stockGasMonitorData[index].statusName!,
                                                  controller.stockGasMonitorData[index].vendorName!,
                                                  controller.stockGasMonitorData[index].manifoldName!,
                                                  controller.stockGasMonitorData[index].serialNo!.toString(),
                                                  controller.stockGasMonitorData[index].consumption!.toString(),
                                                  controller.stockGasMonitorData[index].gasQty!.toString(),
                                                  controller.stockGasMonitorData[index].operatorName!.toString(),
                                                  controller.stockGasMonitorData[index].branchId!,
                                                  controller.stockGasMonitorData[index].gasesId!,
                                                  controller.stockGasMonitorData[index].statusId!,
                                                  controller.stockGasMonitorData[index].vendorId!,
                                                  controller.stockGasMonitorData[index].manifoldId!,
                                                );
                                              }, child: const Icon(Icons.edit_note_outlined , size: 35,color: Colors.deepPurpleAccent,)),
                                              const SizedBox(width: 20,),
                                              InkWell(onTap: (){
                                                deleteGasMonitorData(context, controller.stockGasMonitorData[index].gasMonitorId!);
                                              }, child: const Icon(Icons.delete_forever_sharp , size: 30, color: Colors.red,)),
                                            ],
                                          ),
                                        ),
                                        const MyTextWidget(
                                          title: "Status",
                                          body: "In Stock",
                                        ),
                                        MyTextWidget(
                                          title: "Starting On",
                                          body: startingDate,
                                        ),
                                        MyTextWidget(
                                          title: "Serial No",
                                          body: controller
                                              .stockGasMonitorData[index].serialNo
                                              .toString(),
                                        ),
                                        MyTextWidget(
                                          title: "Total Qty",
                                          body: controller
                                              .stockGasMonitorData[index].gasQty
                                              .toString(),
                                        ),
                                        MyTextWidget(
                                          title: "Balance Qty",
                                          body: controller
                                              .stockGasMonitorData[index]
                                              .remainingStock
                                              .toString(),
                                        ),
                                        MyTextWidget(
                                          title: "Total Days Left",
                                          body: controller
                                              .stockGasMonitorData[index]
                                              .remainingStockDays
                                              .toString(),
                                        ),
                                        MyTextWidget(
                                          title: "Last Date",
                                          body: dueDate,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),

    );
  }

  void addGasMonitorData(BuildContext context) {

    AlertDialog alertDialog = AlertDialog(
      actions: [
        ElevatedButton(onPressed: ()=>Get.back(), child: const Text("Cancel")),
        ElevatedButton(onPressed: ()=>controller.addGasMonitorData(), child: const Text("Submit")),

      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
                  () => TextFormWidget(
                dropDown: true,
                titleText: "Select Branch",
                dropDownOnChanged: (value) {
                  log(value.toString());
                },
                dropDownWidth: w / 1.6,
                dropDownItems: controller.branchData.map((branch) {
                  return DropdownMenuItem<String>(
                      value: branch["branch_name"],
                      onTap: () {
                        controller.selectedBranchId.value =
                        branch["branch_id"];

                      },
                      child: Text(branch["branch_name"]));
                }).toList(),
              ),
            ),
            Obx(
                  () => TextFormWidget(
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.gasData.map((gases) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedGasId.value = gases["gases_id"];
                        print(controller.selectedGasId.value);

                      },
                      value: gases["gases_name"],
                      child: Text(gases["gases_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Gas",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.gasStatus.map((status) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedGasStatus.value = status["status_id"];

                      },
                      value: status["status_name"],
                      child: Text(status["status_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Status",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.vendorData.map((vendor) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedVendorId.value =
                        vendor["vendor_id"];

                      },
                      value: vendor["vendor_name"],
                      child: Text(vendor["vendor_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Vendor",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.manifoldData.map((manifold) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedManifoldId.value =
                        manifold["manifold_id"];

                      },
                      value: manifold["manifold_name"],
                      child: Text(manifold["manifold_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Manifold",
                  dropDownWidth: w / 1.6),
            ),
            TextFormWidget(dropDown: false, titleText: "Serial No" ,textController: controller.addSerialNoController, ),
            TextFormWidget(dropDown: false, titleText: "Consumption/Day" , textController: controller.addConsumptionNoController,),
            TextFormWidget(dropDown: false, titleText: "Gas Qty" , textController: controller.addGasQtyNoController,),
            TextFormWidget(dropDown: false, titleText: "Operator Name" , textController: controller.addOperatorNameController,),


          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context){
      return alertDialog;
    });

  }
  void updateGasMonitorData(BuildContext context , int id , String branchName , String gasName , String status , String vendorName ,String manifold , String serialNo , String consumption, String gasQty , String operatorName , int branchId , int gasId , int statusId , int vendorId ,int manifoldId ){
    AlertDialog alertDialog = AlertDialog(
      actions: [
        ElevatedButton(onPressed: ()=>Get.back(), child: const Text("Cancel")),
        ElevatedButton(onPressed: ()=>controller.updateGasMonitorData(id , operatorName , gasQty ,consumption , serialNo ,branchId , gasId , statusId , vendorId ,manifoldId ), child: const Text("Submit")),

      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextFormWidget(
              dropDownValue: branchName,
                dropDown: true,
                titleText: "Select Branch",
                dropDownOnChanged: (value) {
                  log(value.toString());
                },
                dropDownWidth: w / 1.6,
                dropDownItems: controller.branchData.map((branch) {
                  return DropdownMenuItem<String>(
                      value: branch["branch_name"],
                      onTap: () {
                        controller.selectedBranchId.value =
                        branch["branch_id"];

                      },
                      child: Text(branch["branch_name"]));
                }).toList(),
              ),
            ),
            Obx(
                  () => TextFormWidget(
                    dropDownValue: gasName,
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.gasData.map((gases) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedGasId.value =
                        gases["gases_id"];

                      },
                      value: gases["gases_name"],
                      child: Text(gases["gases_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Gas",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                    dropDownValue: status,
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.gasStatus.map((status) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedGasStatus.value = status["status_id"];

                      },
                      value: status["status_name"],
                      child: Text(status["status_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Status",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                    dropDownValue: vendorName,
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.vendorData.map((vendor) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedVendorId.value =
                        vendor["vendor_id"];

                      },
                      value: vendor["vendor_name"],
                      child: Text(vendor["vendor_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Vendor",
                  dropDownWidth: w / 1.6),
            ),
            Obx(
                  () => TextFormWidget(
                    dropDownValue: manifold,
                  dropDownOnChanged: (value) {},
                  dropDownItems: controller.manifoldData.map((manifold) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        controller.selectedManifoldId.value =
                        manifold["manifold_id"];

                      },
                      value: manifold["manifold_name"],
                      child: Text(manifold["manifold_name"]),
                    );
                  }).toList(),
                  dropDown: true,
                  titleText: "Select Manifold",
                  dropDownWidth: w / 1.6),
            ),
            TextFormWidget(hintText: serialNo, dropDown: false, titleText: "Serial No" ,textController: controller.updateSerialNoController, ),
            TextFormWidget(hintText: consumption, dropDown: false, titleText: "Consumption/Day" , textController: controller.updateConsumptionNoController,),
            TextFormWidget(hintText: gasQty, dropDown: false, titleText: "Gas Qty" , textController: controller.updateGasQtyNoController,),
            TextFormWidget(hintText: operatorName, dropDown: false, titleText: "Operator Name" , textController: controller.updateOperatorNameController,),

          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context){
      return alertDialog;
    });
  }


  void deleteGasMonitorData(BuildContext context , int id){
    AlertDialog alertDialog =  AlertDialog(
      actions: [
        ElevatedButton(onPressed: ()=>Get.back(), child: const Text("Cancel")),
        ElevatedButton(onPressed: ()=>controller.deleteGasMonitorData(id), child: const Text("Submit")),
      ],
      content: const Text("Are You Sure Want to Delete ?"),
    );
    showDialog(context: context, builder: (context){
      return alertDialog;
    });
  }
}
