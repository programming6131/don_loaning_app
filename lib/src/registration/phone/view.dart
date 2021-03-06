import 'package:don/src/constants/colors.dart';
import 'package:don/src/constants/constants.dart';
import 'package:don/src/registration/phone/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Phone extends StatefulWidget {
   Phone({Key? key}) : super(key: key);
  static const routeName = '/phone';

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
final cont = Get.put(PhoneController());

  @override
  Widget build(BuildContext context) {
    final getScreenHeightSize = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 44.h),
                Container(
                  height: 264.h,
                  color: primaryColor,
                  child: Center(
                    child: Image.asset('assets/images/dol.png'),
                  ),
                ),
                SizedBox(height: 44.h),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Container(
                    height: getScreenHeightSize / 2,
                    decoration: BoxDecoration(
                      color: cardLightColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                          child: Container(
                            height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffF2F3F3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.r)),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0.w, top: 2.h),
                                      child: Text(
                                        "Mobile",
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(color: Color(0xff878787)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.0.w),
                                      child:
                                          Image.asset("assets/images/flag.png"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 250.w,
                                  height: 50.h,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: cont.phoneController,
                                    style: theme.textTheme.bodyText1,
                                    decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: "+254- x-xx-xxx-xx",
                                        hintStyle: TextStyle(color: Color(0xff878787))
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                         Padding(
              padding: EdgeInsets.only(top: 46.h, left: 150.w, right: 150.w),
              child: GestureDetector(
                onTap: () {
                  cont.phoneMethod();
                },
                child: Container(
                  height: 38.h,
                  width: 38.w,
                  child: Image.asset("assets/images/go.png"),
                ),
              ),
            ),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
