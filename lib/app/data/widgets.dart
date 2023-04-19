import 'package:flutter/material.dart';
import 'package:gas_bank_operator/app/modules/gas_manifold/views/gas_manifold_view.dart';
import 'package:gas_bank_operator/app/modules/gas_monitor/views/gas_monitor_view.dart';
import 'package:gas_bank_operator/app/modules/gas_vendor/views/gas_vendor_view.dart';
import 'package:gas_bank_operator/app/modules/gases/views/gases_view.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'constants.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget(
      {Key? key,
      this.dropDownItems,
      this.dropDownOnChanged,
      required this.dropDown,
      required this.titleText,
      this.hintText,
      this.maxLines,
      this.textController,
      this.textBoxWidth,
      this.dropDownWidth,
      this.keyboardType,
      this.textBoxHeight,
      this.dropDownHeight,
      this.onTextChanged,
      this.readOnly,
      this.suffixIcon,
      this.onTapTextBox,
      this.borderSideTextBox,
      this.borderSideDropDown, this.dropDownValue, this.textHintStyle})
      : super(key: key);
  final List<DropdownMenuItem<Object>>? dropDownItems;
  final Function(Object?)? dropDownOnChanged;
  final bool dropDown;
  final String titleText;
  final String? hintText;
  final int? maxLines;
  final TextEditingController? textController;
  final double? textBoxWidth;
  final double? dropDownWidth;
  final double? textBoxHeight;
  final double? dropDownHeight;
  final TextInputType? keyboardType;
  final Function(String)? onTextChanged;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Function()? onTapTextBox;
  final BorderSide? borderSideTextBox;
  final BorderSide? borderSideDropDown;
  final Object? dropDownValue;
  final TextStyle? textHintStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: const TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        (dropDown == true)
            ? Container(
                height: dropDownHeight,
                width: dropDownWidth,
                color: Colors.transparent,
                child: DropdownButtonFormField(
                  value: dropDownValue,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 30,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                          borderSide: borderSideDropDown ?? const BorderSide(),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: dropDownItems,
                    onChanged: dropDownOnChanged),
              )
            : Container(
                height: textBoxHeight,
                width: textBoxWidth,
                color: Colors.grey.shade100,
                child: TextFormField(
                  onChanged: onTextChanged,
                  controller: textController,
                  maxLines: maxLines,
                  minLines: 1,
                  readOnly: readOnly ?? false,
                  keyboardType: keyboardType ?? TextInputType.text,
                  onTap: onTapTextBox,
                  decoration: InputDecoration(
                    suffixIcon: suffixIcon,
                    contentPadding: const EdgeInsets.all(10),
                    isDense: (maxLines != null) ? true : false,
                    hintText: hintText ?? "Enter $titleText",
                    hintStyle: textHintStyle,
                    border: OutlineInputBorder(
                      borderSide: borderSideTextBox ?? const BorderSide(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({Key? key, required this.title, required this.onTap}) : super(key: key);
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
          width: w,
          child:  Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ))),
    );
  }
}

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({Key? key, required this.title, this.isContainer, this.body}) : super(key: key);
  final String title;
  final String? body;
  final bool? isContainer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10 , right: 10 , top: 8 , bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500 , color: Colors.deepPurple),),

              Text((body == null)?"":body!,style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500 )),
            ],
          ),
        ),
        (isContainer == false)?Container(): Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey.withOpacity(0.5)
        ),
      ],
    );
  }
}

class MyBottomNavigation extends StatelessWidget {
  MyBottomNavigation({Key? key}) : super(key: key);
  final RxInt selected = 1.obs;
  final _controller = PersistentTabController(initialIndex: 0,);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          title: "Gas Monitor",
          textStyle: const TextStyle(fontSize: 16 ),
          iconSize: 25,
          icon: const Icon(Icons.monitor , size: 30,),
        activeColorPrimary: Colors.purpleAccent,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        iconSize: 25,
        title: "Gases",
        textStyle: const TextStyle(fontSize: 16 ),
        icon:const Icon(Icons.gas_meter , size: 30),
        activeColorPrimary: Colors.redAccent,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Colors.white,

      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontSize: 16 ),
        iconSize: 25,
        title: "Gas Manifold",
        icon: const Icon(Icons.gas_meter_sharp, size: 30,),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        textStyle: const TextStyle(fontSize: 16 ),
        title: "Gas Vendor",
        iconSize: 25,
        icon: const Icon(Icons.person , size: 30,),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.grey,
        activeColorSecondary: Colors.white,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      GasMonitorView(),
      GasesView(),
      GasManifoldView(),
      GasVendorView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () =>(selected.value == 0)?Container(): PersistentTabView(
        context,
        controller: _controller,
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style7,
        screens: _buildScreens(),
        decoration: const NavBarDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(5.0, 5.0,),
                blurRadius: 6.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                // color: secondaryColor,
                offset: Offset(5.0, 5.0),
                blurRadius: 6.0,
                spreadRadius: 0.0,
              ),
            ],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      ),
    );
  }
}
