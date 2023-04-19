import 'package:flutter/material.dart';
import 'package:gas_bank_operator/app/data/widgets.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome To Gas Bank'),
          centerTitle: true,
        ),
        bottomNavigationBar: MyBottomNavigation(),
      ),
    );
  }
}
