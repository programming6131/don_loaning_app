
import 'package:don/src/Home/view.dart';
import 'package:don/src/Loans/view.dart';
import 'package:don/src/Profile/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {

  var isSelected = 0;
var data = Get.arguments;
  Widget tab() {
    //provisions to check role and pick correct tabs
    return tabClient[isSelected];
  }

  updateSelected(index){
    print(index);
    isSelected = index;
    update();
    // return tabClient[index];
  }
  //Control User Action Dialogs
  //
  var tabClient = [
    HomeView(),
    Loans(),
   ProfileView(),
  ];

  var tabAgent = [
  ];
}
